import 'dart:io';

import 'package:mason/mason.dart';

Future<void> run(HookContext context) async {
  await _runDartFormat(context);
  await _runDartFix(context);
  await _runBuildBloc(context);
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

Future<void> _runBuildBloc(HookContext context) async {
  final formatProgress = context.logger.progress('Creating bloc');
  final outdir = context.vars['-o'] as String? ?? Directory.current.path;

  try {
    final result = await Process.run('mason', ['make', 'bloc', '-o', outdir]);

    // Cek exit code
    if (result.exitCode != 0) {
      formatProgress.fail('Create bloc failed');
      context.logger.err('Error: ${result.stderr}');
      return;
    }

    // Print output (optional)
    if (result.stdout.toString().isNotEmpty) {
      context.logger.info(result.stdout.toString());
    }

    formatProgress.complete('Create bloc completed');
  } catch (e) {
    formatProgress.fail('Create bloc failed');
    context.logger.err('Exception: $e');
  }
}
