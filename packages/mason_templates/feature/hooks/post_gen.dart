import 'dart:convert';
import 'dart:io';

import 'package:mason/mason.dart';

import '../../bloc/models/bloc_config.dart';
import '../../utils/error_utils.dart';
import '../../utils/initial_runner_utils.dart';

Future<void> run(HookContext context) async {
  try {
    final generateBloc = context.vars['generate_bloc'] as bool;
    final name = context.vars['name'] as String;
    final outputDir = '${context.vars['output_dir'] as String}/$name';

    // addDependencies, pubGet, buildRunner dijalankan di brick bloc
    // jika generate_bloc true, jadi skip di sini
    if (!generateBloc) {
      await addDependencies(context);
      await runPubGet(context);
      await runBuildRunner(context);
    }

    await _runBuildBloc(context);
    await runDartFix(context, outputDir: outputDir);
    await runDartFormat(context, outputDir: outputDir);

    context.logger.success('Generated successfully!');
  } catch (e) {
    context.logger.err('Generation Aborted: ${e.message}');
    exit(1);
  }
}

Future<void> _runBuildBloc(HookContext context) async {
  final generateBloc = context.vars['generate_bloc'] as bool;

  if (!generateBloc) return;

  final name = context.vars['name'] as String;
  final outputDir =
      '${context.vars['output_dir'] as String}/$name/presentation/blocs';

  final config = BlocConfig(
    name: name,
    blocType: context.vars['bloc_type'],
    runBuildRunner: context.vars['run_build_runner'],
    outputDir: outputDir,
    calledFromParent: true,
  );

  final configFile = File('.mason_temp_config.json');
  await configFile.writeAsString(jsonEncode(config.toJson()));

  try {
    final process = await Process.start('cmd', [
      '/c',
      'mason',
      'make',
      'bloc',
      '--config-path',
      configFile.path,
      '-o',
      outputDir,
      '--on-conflict',
      'overwrite',
    ], runInShell: true);

    final stderrBuffer = <int>[];

    await Future.wait([
      process.stdout.forEach(stdout.add),
      process.stderr.forEach((data) {
        stderr.add(data);
        stderrBuffer.addAll(data);
      }),
    ]);

    final exitCode = await process.exitCode;

    if (exitCode != 0) {
      throw Exception(utf8.decode(stderrBuffer));
    }
  } finally {
    await configFile.delete();
  }
}
