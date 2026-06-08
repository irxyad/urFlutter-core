import 'dart:io';

import 'package:mason/mason.dart';
import 'package:path/path.dart' as path;

import '../models/bloc_config.dart';
import 'utils/bloc_type_utils.dart';
import 'utils/directory_utils.dart';
import 'utils/error_utils.dart';
import 'utils/initial_runner_utils.dart';
import 'utils/logger_utils.dart';
import 'utils/move_generated_folder.dart';

Future<void> run(HookContext context) async {
  try {
    final config = BlocConfig.fromContext(context);
    final isStandalone = !config.calledFromParent;

    final folderPath = '${config.outputDir}/${config.name}_${config.blocType}';

    if (isStandalone) {
      await moveGeneratedFolder(
        context,
        name: '${config.name}_${config.blocType}',
        outputDir: folderPath,
      );
      await runDartFix(context, outputDir: folderPath);
      await runDartFormat(context, outputDir: folderPath);
    }

    _handleBlocEventFile(context, config: config, folderPath: folderPath);
    await addDependencies(context);
    await runPubGet(context);
    await runBuildRunner(context);

    context.logger.success('Generated successfully!');
  } catch (e) {
    context.logger.err('Generation Aborted! ${e.message}');
    exit(1);
  }
}

// Untuk menghapus file event jika ia hanya generate cubit
void _handleBlocEventFile(
  HookContext context, {
  required BlocConfig config,
  required String folderPath,
}) {
  if (config.blocType != BlocType.cubit.value) return;

  final projectRoot = findProjectRoot();
  final absoluteFolderPath = path.normalize(
    path.join(projectRoot.path, folderPath),
  );

  final eventFile = File('$absoluteFolderPath/${config.name}_event.dart');

  if (eventFile.existsSync()) {
    eventFile.deleteSync();
    context.logger.done('Deleted', hint: eventFile.path);
  }
}
