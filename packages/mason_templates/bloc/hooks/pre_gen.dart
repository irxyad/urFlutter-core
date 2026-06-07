import 'dart:io';

import 'package:mason/mason.dart';

import '../enums/bloc_types.dart';

Future<void> run(HookContext context) async {
  final outDir = context.vars['output_dir'] as String?;

  if (outDir != null) {
    context.vars = {...context.vars, 'outputDir': outDir};
  }
  _setBlocType(context);
}

void _setBlocType(HookContext context) {
  try {
    final type = context.vars['bloc_type'] as String;

    final isValid = BlocTypes.values.any((element) => element.value == type);

    if (!isValid) {
      throw Exception('$type is not a valid type');
    }

    context.vars = {
      ...context.vars,
      'isBloc': type == BlocTypes.bloc.value,
      'isCubit': type == BlocTypes.cubit.value,
    };
    context.logger.info('$type selected');
    context.logger.info('${context.vars}');
  } catch (e) {
    context.logger.err('Generation Aborted: $e');
    exit(1);
  }
}
