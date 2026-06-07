import 'dart:io';

import 'package:mason/mason.dart';

import '../../utils/bloc_type_utils.dart';
import '../../utils/build_runner_utils.dart';
import '../../utils/check_existing_folder_utils.dart';
import '../../utils/error_utils.dart';
import '../../utils/resolve_output_dir_utils.dart';
import '../../utils/validate_name_utils.dart';

Future<void> run(HookContext context) async {
  try {
    validateName(
      context,
      label: 'What is the feature name? (e.g. auth, home, profile)',
    );
    resolveOutputDir(context);
    _resolveGenerateBloc(context);
    resolveBuildRunner(context);

    final outputDir = context.vars['output_dir'] as String;
    final name = context.vars['name'] as String;
    final folderPath = '$outputDir/$name';

    checkExistingFolder(context, folderPath: folderPath);
  } catch (e) {
    context.logger.err('Generation Aborted! ${e.message}');
    exit(1);
  }
}

/// Resolve apakah akan generate bloc dan tipe-nya.
void _resolveGenerateBloc(HookContext context) {
  final existing = context.vars['generate_bloc'] as bool?;

  final generateBloc =
      existing ??
      context.logger.confirm(
        'Generate a bloc for this feature?',
        defaultValue: true,
      );

  context.vars = {...context.vars, 'generate_bloc': generateBloc};

  if (!generateBloc) return;

  final blocType = resolveBlocType(context);
  context.vars = {...context.vars, 'bloc_type': blocType.value};
}
