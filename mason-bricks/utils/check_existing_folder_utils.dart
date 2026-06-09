import 'dart:io';

import 'package:mason/mason.dart';

enum _OverwriteChoice {
  overwrite('Overwrite', 'Delete & Regenerate'),
  cancel('Cancel', 'Cancel');

  final String value;
  final String label;

  const _OverwriteChoice(this.value, this.label);
}

/// Mengecek apakah folder [folderPath] sudah ada.
///
/// Jika sudah ada, user akan diminta memilih antara overwrite atau cancel
void checkExistingFolder(HookContext context, {required String folderPath}) {
  final dir = Directory(folderPath);

  if (!dir.existsSync()) return;

  context.logger.warn('Folder "$folderPath" already exists.');

  final choice = context.logger.chooseOne(
    'What do you want to do?',
    choices: _OverwriteChoice.values,
    defaultValue: _OverwriteChoice.overwrite,
    display: (choice) => choice.label,
  );

  if (choice == _OverwriteChoice.cancel) {
    context.logger.warn('Generation cancelled.');
    exit(0);
  }

  dir.deleteSync(recursive: true);
  context.logger.info('Folder "$folderPath" removed, regenerating...');
}
