import 'dart:io';

import 'package:mason/mason.dart';

import '../../utils/bloc_type_utils.dart';
import '../../utils/build_runner_utils.dart';
import '../../utils/check_existing_folder_utils.dart';
import '../../utils/error_utils.dart';
import '../../utils/resolve_output_dir_utils.dart';
import '../../utils/validate_name_utils.dart';

Future<void> run(HookContext context) async {
  context.logger.info('Pregen hook');
}
