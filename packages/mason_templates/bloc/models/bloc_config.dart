import 'package:mason/mason.dart';

/// Ini dipake untuk melempar args ke brick bloc
/// yang tidak ada di brick.yaml nya
class BlocConfig {
  final String name;
  final String blocType;
  final bool runBuildRunner;
  final String outputDir;
  final bool calledFromParent;

  BlocConfig({
    required this.name,
    required this.blocType,
    required this.runBuildRunner,
    required this.outputDir,
    this.calledFromParent = false,
  });

  factory BlocConfig.fromContext(HookContext context) {
    return BlocConfig(
      name: context.vars['name'],
      blocType: context.vars['bloc_type'],
      runBuildRunner: context.vars['run_build_runner'],
      outputDir: context.vars['output_dir'],
      calledFromParent: context.vars['called_from_parent'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'bloc_type': blocType,
      'run_build_runner': runBuildRunner,
      'output_dir': outputDir,
      'called_from_parent': calledFromParent,
    };
  }
}
