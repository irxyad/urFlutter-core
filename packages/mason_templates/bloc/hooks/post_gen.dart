import 'dart:io';

import 'package:mason/mason.dart';

Future<void> run(HookContext context) async {
  await _addDependencies(context);
  await _runDartFormat(context);
  await _runDartFix(context);
  await _runPubGet(context);
  if (context.vars['run_build_runner'] as bool) {
    await _runBuildRunner(context);
  }
}

Future<void> _runDartFormat(HookContext context) async {
  final formatProgress = context.logger.progress('Running "dart format"');
  await Process.run('dart', ['format', '.']);
  formatProgress.complete();
}

Future<void> _runDartFix(HookContext context) async {
  final formatProgress = context.logger.progress('Running "dart fix --apply"');
  await Process.run('dart', ['fix', '--apply']);
  formatProgress.complete();
}

Future<void> _addDependencies(HookContext context) async {
  final depedencies = ['freezed_annotation', 'injectable', 'bloc'];

  final devDependencies = [
    'freezed',
    'build_runner',
    'injectable_generator',
    'json_serializable',
  ];

  final formatProgress = context.logger.progress(
    'Adding dependencies (${[...depedencies, ...devDependencies].join(', ')}) ',
  );

  await Process.run('dart', ['pub', 'add', ...depedencies]);
  await Process.run('dart', ['pub', 'add', '--dev', ...devDependencies]);

  formatProgress.complete();
}

Future<void> _runBuildRunner(HookContext context) async {
  final formatProgress = context.logger.progress('Running "build runner"');

  try {
    final result = await Process.run('dart', [
      'run',
      'build_runner',
      'build',
      '--delete-conflicting-outputs',
    ]);

    // Cek exit code
    if (result.exitCode != 0) {
      formatProgress.fail('Build runner failed');
      context.logger.err('Error: ${result.stderr}');
      return;
    }

    // Print output (optional)
    if (result.stdout.toString().isNotEmpty) {
      context.logger.info(result.stdout.toString());
    }

    formatProgress.complete('Build runner completed');
  } catch (e) {
    formatProgress.fail('Build runner failed');
    context.logger.err('Exception: $e');
  }
}

Future<void> _runPubGet(HookContext context) async {
  final formatProgress = context.logger.progress('Running pub get...');

  try {
    final result = await Process.run(
      'flutter',
      ['pub', 'get'],
      workingDirectory: Directory.current.path,
      runInShell: true,
    );

    if (result.exitCode == 0) {
      formatProgress.complete();
    } else {
      formatProgress.fail();
    }
  } catch (e) {
    formatProgress.fail();
    context.logger.err('$e');
  }
}
