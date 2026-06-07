import 'dart:io';

import 'package:mason/mason.dart';

import '../../utils/bloc_type_utils.dart';
import '../../utils/build_runner_utils.dart';
import '../../utils/check_existing_folder_utils.dart';
import '../../utils/error_utils.dart';
import '../../utils/resolve_output_dir_utils.dart';
import '../../utils/validate_name_utils.dart';
import '../models/bloc_config.dart';

Future<void> run(HookContext context) async {
  try {
    validateName(
      context,
      label: 'What is the bloc name? (e.g. auth, home, profile)',
      hint: 'without bloc/cubit suffix',
    );
    resolveOutputDir(context);
    _resolveBlocType(context);
    resolveBuildRunner(context);

    final config = BlocConfig.fromContext(context);
    final folderPath = '${config.outputDir}/${config.name}_${config.blocType}';

    checkExistingFolder(context, folderPath: folderPath);
  } catch (e) {
    context.logger.err('Generation Aborted: ${e.message}');

    exit(1);
  }
}

void _resolveBlocType(HookContext context) {
  final argBlocType = context.vars['bloc_type'] as String?;

  // Jika sudah ada, berarti dipanggil dari parent brick
  if (argBlocType != null) {
    final blocType = BlocType.fromString(argBlocType);
    _setBlocTypeVars(context, blocType);
    return;
  }

  final blocType = resolveBlocType(context);
  _setBlocTypeVars(context, blocType);
}

void _setBlocTypeVars(HookContext context, BlocType blocType) {
  context.vars = {
    ...context.vars,
    'bloc_type': blocType.value,
    'isBloc': blocType == BlocType.bloc,
    'isCubit': blocType == BlocType.cubit,
  };
}
