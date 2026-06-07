import 'dart:io';

import 'package:mason/mason.dart';

import '../../utils/initial_runner_utils.dart';

Future<void> run(HookContext context) async {
  try {
    final generateBloc = context.vars['generate_bloc'] as bool;
    final outputDir = context.vars['output_dir'] as String;

    // Kalau generate bloc true maka kita skip ini
    // karena udah dijalankan di brick bloc nya
    if (!generateBloc) {
      await addDependencies(context);
      await runPubGet(context);
      await runBuildRunner(context);
    }

    await runDartFormat(context, outputDir: outputDir);
    await runDartFix(context, outputDir: outputDir);
    await _runBuildBloc(context);

    context.logger.success('Generated successfully!');
  } catch (e) {
    context.logger.err('Generation Aborted: $e');
  }
}

// Kita manggil brick bloc dengan melempar args sesuai yang diminta
Future<void> _runBuildBloc(HookContext context) async {
  final generateBloc = context.vars['generate_bloc'] as bool;

  if (!generateBloc) return;

  final outdir = context.vars['output_dir'] as String;
  final name = context.vars['name'] as String;

  final args = <String>[
    '/c',
    'mason',
    'make',
    'bloc',
    '--name',
    context.vars['name'].toString(),
    '--bloc_type',
    context.vars['bloc_type'].toString(),
    '--run_build_runner',
    context.vars['run_build_runner'].toString(),
    '--output_dir',
    '${name}_bloc',
    '-o',
    '$outdir/$name/presentation/blocs',
    '--on-conflict',
    'overwrite',
  ];

  final process = await Process.start('cmd', args, runInShell: true);

  await Future.wait([
    process.stdout.forEach((data) => stdout.add(data)),
    process.stderr.forEach((data) => stderr.add(data)),
  ]);

  final exitCode = await process.exitCode;

  if (exitCode != 0) {
    context.logger.err('Failed to generate bloc with error: ${args.join(' ')}');
  }
}
