import 'dart:io';

import 'package:mason/mason.dart';

Future<void> run(HookContext context) async {
  try {
    if (context.vars['validatePath'] == 'No') {
      throw Exception(
        'Please open the terminal in the correct folder or use -o <path>.',
      );
    }

    context.vars = {...context.vars};
  } catch (e) {
    context.logger.err('Generation Aborted: $e');
    exit(1);
  }
}
