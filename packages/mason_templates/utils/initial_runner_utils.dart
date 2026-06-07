import 'dart:io';

import 'package:mason/mason.dart';

Future<void> addDependencies(HookContext context) async {
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

Future<void> runPubGet(HookContext context) async {
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

Future<void> runDartFormat(
  HookContext context, {
  required String outputDir,
}) async {
  final formatProgress = context.logger.progress(
    'Running "dart format" on $outputDir',
  );

  await Process.run('dart', ['format', outputDir]);
  formatProgress.complete();
}

Future<void> runDartFix(
  HookContext context, {
  required String outputDir,
}) async {
  final formatProgress = context.logger.progress(
    'Running "dart fix --apply" on $outputDir',
  );

  await Process.run('dart', ['fix', '--apply', outputDir]);
  formatProgress.complete();
}

Future<void> runBuildRunner(HookContext context) async {
  final runBuildRunner = context.vars['run_build_runner'] as bool;

  if (!runBuildRunner) return;

  final formatProgress = context.logger.progress('Running "build runner"');

  try {
    final result = await Process.run('dart', [
      'run',
      'build_runner',
      'build',
      '--delete-conflicting-outputs',
    ]);

    if (result.exitCode != 0) {
      formatProgress.fail('Build runner failed');
      context.logger.err('Error: ${result.stderr}');
      return;
    }

    if (result.stdout.toString().isNotEmpty) {
      context.logger.info(result.stdout.toString());
    }

    formatProgress.complete('Build runner completed');
  } catch (e) {
    formatProgress.fail('Build runner failed');
    context.logger.err('Exception: $e');
  }
}
