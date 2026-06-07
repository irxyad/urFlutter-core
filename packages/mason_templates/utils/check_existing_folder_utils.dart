import 'dart:io';

import 'package:mason/mason.dart';

void checkExistingFolder(HookContext context, {required String folderName}) {
  final featureDir = Directory(folderName);

  if (!featureDir.existsSync()) return;

  final choice = context.logger.chooseOne(
    'Folder "$folderName" already exists, what do you want to do?',
    choices: ['Overwrite', 'Cancel'],
    defaultValue: 'Overwrite',
  );

  if (choice == 'Cancel') {
    context.logger.warn('Generation cancelled.');
    exit(0);
  }

  if (choice == 'Overwrite') {
    featureDir.deleteSync(recursive: true);
    context.logger.info(
      'Existing folder "$folderName" removed, regenerating...',
    );
  }
}
