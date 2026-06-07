import 'package:mason/mason.dart';

/// Prompt apakah akan run build_runner
void resolveBuildRunner(HookContext context) {
  final existing = context.vars['run_build_runner'] as bool?;

  if (existing != null) return;

  final runBuildRunner = context.logger.confirm(
    'Run build_runner after generation?',
    defaultValue: true,
  );

  context.vars = {...context.vars, 'run_build_runner': runBuildRunner};
}
