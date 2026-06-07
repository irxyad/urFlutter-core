import 'dart:io';

import 'package:mason/mason.dart';

import '../../bloc/enums/bloc_types.dart';
import '../../utils/check_existing_folder_utils.dart';
import '../../utils/set_output_dir_utils.dart';

Future<void> run(HookContext context) async {
  try {
    _validateName(context);
    setOutputDir(context);

    final outputDir = context.vars['output_dir'] as String;
    final folderName = '$outputDir/${context.vars['name']}';
    context.logger.info('Output Directory: $folderName');
    checkExistingFolder(context, folderName: folderName);

    _promptBuildRunner(context);
    _promptGenerateBloc(context);
    _setBlocType(context);
  } catch (e) {
    context.logger.err('Generation Aborted: $e');
    exit(1);
  }
}

/// Ngeset apakah akan generate bloc atau cubit
void _setBlocType(HookContext context) {
  final isGenerateBloc = context.vars['generate_bloc'] as bool;

  if (!isGenerateBloc) return;

  final blocType = context.logger.chooseOne(
    'Select the state management type',
    choices: [BlocTypes.bloc.value, BlocTypes.cubit.value],
    defaultValue: BlocTypes.bloc.value,
  );

  context.vars = {...context.vars, 'bloc_type': blocType};
}

/// Prompt apakah akan run build_runner
void _promptBuildRunner(HookContext context) {
  final isRunBuildRunner = context.logger.chooseOne(
    'Run build_runner after generation?',
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

  context.vars = {...context.vars, 'run_build_runner': isRunBuildRunner};
}

/// Prompt apakah akan generate bloc
void _promptGenerateBloc(HookContext context) {
  final isGenerateBloc = context.logger.chooseOne(
    'Generate a bloc for this feature?',
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

  context.vars = {...context.vars, 'generate_bloc': isGenerateBloc};
}

/// Validasi nama fitur
void _validateName(HookContext context) {
  final name = (context.vars['name'] as String).trim();

  if (name.isEmpty) {
    throw Exception('Name cannot be empty!');
  }

  if (name.contains(' ')) {
    throw Exception('Name cannot contain spaces!, use snake_case instead');
  }

  context.vars = {...context.vars, 'name': name};
}
