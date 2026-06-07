import 'package:mason/mason.dart';

import '../../utils/initial_runner_utils.dart';

Future<void> run(HookContext context) async {
  final outputDir = context.vars['outputDir'] as String;

  await addDependencies(context);
  await runPubGet(context);
  await runBuildRunner(context);
  await runDartFix(context, outputDir: outputDir);
  await runDartFormat(context, outputDir: outputDir);

  context.logger.success('Generated successfully!');
}
