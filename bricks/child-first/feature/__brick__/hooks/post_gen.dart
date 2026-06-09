import 'dart:convert';
import 'dart:io';

import 'package:mason/mason.dart';

import '../../bloc/models/bloc_config.dart';
import '../../utils/error_utils.dart';
import '../../utils/initial_runner_utils.dart';
import '../../utils/move_generated_folder.dart';

Future<void> run(HookContext context) async {
  context.logger.info('Postgen hook');
}
