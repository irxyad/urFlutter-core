import 'package:mason/mason.dart';
import 'package:path/path.dart' as path;

void setOutputDir(HookContext context) {
  final currentPath = './lib/features';

  final isCorrect = context.logger.chooseOne(
    'Generate files in this folder $currentPath?',
    choices: [true, false],
    defaultValue: true,
    display: (choice) {
      if (choice == true) {
        return 'Yes';
      } else {
        return 'No';
      }
    },
  );

  if (isCorrect) {
    context.vars = {...context.vars, 'output_dir': currentPath};
    return;
  }

  while (true) {
    final outputDir = context.logger.prompt(
      'Please paste the correct path (ONLY RELATIVE PATH):',
    );

    if (outputDir.trim().isEmpty) {
      context.logger.warn('Path cannot be empty.');
      continue;
    }

    if (path.isAbsolute(outputDir)) {
      context.logger.warn('Please provide a relative path.');
      continue;
    }

    context.vars = {...context.vars, 'output_dir': outputDir};

    break;
  }
}
