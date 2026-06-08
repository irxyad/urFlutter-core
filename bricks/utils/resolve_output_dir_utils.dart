import 'package:mason/mason.dart';
import 'package:path/path.dart' as path;

const _defaultOutputDir = './lib/features';

/// Untuk ngeresolve output dir
/// jika ada argumen di command line maka langsung di set
/// jika tidak akan muncul prompt
void resolveOutputDir(HookContext context) {
  final existing = context.vars['output_dir'] as String?;

  if (existing != null) return;

  final useDefault = context.logger.confirm(
    'Generate files in "$_defaultOutputDir"?',
    defaultValue: true,
  );

  if (useDefault) {
    context.vars = {...context.vars, 'output_dir': _defaultOutputDir};
    return;
  }

  while (true) {
    final input = context.logger.prompt(
      'Enter the output path (relative path only):',
    );

    if (input.trim().isEmpty) {
      context.logger.warn('Path cannot be empty.');
      continue;
    }

    if (path.isAbsolute(input)) {
      context.logger.warn('Please provide a relative path, not absolute.');
      continue;
    }

    context.vars = {...context.vars, 'output_dir': input};
    break;
  }
}
