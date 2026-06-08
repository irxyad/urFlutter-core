import 'dart:io';

import 'package:mason/mason.dart';

import 'logger_utils.dart';

Future<void> moveGeneratedFolder(
  HookContext context, {
  required String name,
  required String outputDir,
}) async {
  final generated = Directory(name);
  final target = Directory(outputDir);

  if (!generated.existsSync()) {
    throw Exception('Generated folder "$name" not found.');
  }

  if (target.existsSync()) {
    target.deleteSync(recursive: true);
  }

  await target.parent.create(recursive: true);
  await generated.rename(target.path);

  final items = (await target.list(recursive: true).toList());

  context.logger.done('Moved ${items.length} files.');

  for (final item in items) {
    if (item is File) {
      context.logger.write(green.wrap('  created '));
      context.logger.write(darkGray.wrap('${item.path}\n'));
    }
  }
}
