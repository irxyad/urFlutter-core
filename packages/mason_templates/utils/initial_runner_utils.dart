import 'dart:io';

import 'package:mason/mason.dart';
import 'package:path/path.dart' as path;

final _dependencies = ['freezed_annotation', 'injectable', 'bloc'];

final _devDependencies = [
  'freezed',
  'build_runner',
  'injectable_generator',
  'json_serializable',
];

/// Menambahkan [depedencies] dan [devDependencies] seperti freezed, injectable dll
Future<void> addDependencies(HookContext context) async {
  final progress = context.logger.progress(
    'Adding dependencies (${[..._dependencies, ..._devDependencies].join(', ')})',
  );

  try {
    final results = await Future.wait([
      Process.run('dart', ['pub', 'add', ..._dependencies], runInShell: true),
      Process.run('dart', [
        'pub',
        'add',
        '--dev',
        ..._devDependencies,
      ], runInShell: true),
    ]);

    final failed = results.where((r) => r.exitCode != 0);

    if (failed.isNotEmpty) {
      progress.fail();
      throw Exception(failed.map((r) => r.stderr.toString()).join('\n'));
    }

    progress.complete();
  } catch (e) {
    progress.fail();
    rethrow;
  }
}

Future<void> runPubGet(HookContext context) async {
  final progress = context.logger.progress('Running "flutter pub get"');

  try {
    final result = await Process.run(
      'flutter',
      ['pub', 'get'],
      workingDirectory: Directory.current.path,
      runInShell: true,
    );

    if (result.exitCode != 0) {
      progress.fail();
      throw Exception(result.stderr.toString());
    }

    progress.complete();
  } catch (e) {
    progress.fail();
    rethrow;
  }
}

Future<void> runDartFormat(
  HookContext context, {
  required String outputDir,
}) async {
  var projectRoot = Directory.current;

  while (!File('${projectRoot.path}/pubspec.yaml').existsSync()) {
    projectRoot = projectRoot.parent;
  }

  final absoluteOutputDir = path.normalize(
    path.join(projectRoot.path, outputDir),
  );

  final progress = context.logger.progress(
    'Running "dart format" on $outputDir',
  );

  try {
    final result = await Process.run(
      'dart',
      ['format', '.'],
      workingDirectory: absoluteOutputDir,
      runInShell: true,
    );

    if (result.exitCode != 0) {
      progress.fail();
      throw Exception(result.stderr.toString());
    }

    progress.complete();
  } catch (e) {
    progress.fail();
    rethrow;
  }
}

Future<void> runDartFix(
  HookContext context, {
  required String outputDir,
}) async {
  final progress = context.logger.progress(
    'Running "dart fix --apply" on $outputDir',
  );

  try {
    var projectRoot = Directory.current;

    while (!File('${projectRoot.path}/pubspec.yaml').existsSync()) {
      projectRoot = projectRoot.parent;
    }

    final absoluteOutputDir = path.normalize(
      path.join(projectRoot.path, outputDir),
    );

    final result = await Process.run(
      'dart',
      ['fix', '--apply', '.'],
      workingDirectory: absoluteOutputDir,
      runInShell: true,
    );

    if (result.exitCode != 0) {
      progress.fail();
      throw Exception(result.stderr.toString());
    }

    progress.complete();
  } catch (e) {
    progress.fail();
    rethrow;
  }
}

Future<void> runBuildRunner(HookContext context) async {
  final runBuildRunner = context.vars['run_build_runner'] as bool;

  if (!runBuildRunner) return;

  final progress = context.logger.progress('Running "build_runner build"');

  try {
    var projectRoot = Directory.current;
    while (!File('${projectRoot.path}/pubspec.yaml').existsSync()) {
      projectRoot = projectRoot.parent;
    }

    final result = await Process.run(
      'dart',
      ['run', 'build_runner', 'build', '--delete-conflicting-outputs'],
      workingDirectory: projectRoot.path,
      runInShell: true,
    );

    if (result.exitCode != 0) {
      progress.fail();
      throw Exception(result.stderr.toString());
    }

    progress.complete();
  } catch (e) {
    progress.fail();
    rethrow;
  }
}
