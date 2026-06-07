import 'dart:io';

import 'package:mason/mason.dart';

import '../../utils/initial_runner_utils.dart';
import '../models/bloc_config.dart';

Future<void> run(HookContext context) async {
  try {
    final config = BlocConfig.fromContext(context);
    final isStandalone = !(config.calledFromParent ?? false);

    final folderPath = '${config.outputDir}/${config.name}_${config.blocType}';

    await addDependencies(context);
    await runPubGet(context);
    await runBuildRunner(context);

    if (isStandalone) {
      await runDartFix(context, outputDir: folderPath);
      await runDartFormat(context, outputDir: folderPath);
    }

    context.logger.success('Generated successfully!');
  } catch (e) {
    context.logger.err('Generation Aborted! $e');
    exit(1);
  }
}
