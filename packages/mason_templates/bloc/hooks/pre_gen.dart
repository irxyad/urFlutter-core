import 'dart:io';

import 'package:mason/mason.dart';

enum BlocType {
  bloc('bloc'),
  cubit('cubit');

  final String value;
  const BlocType(this.value);
}

Future<void> run(HookContext context) async {
  try {
    if (context.vars['validatePath'] == 'No') {
      throw Exception(
        'Please open the terminal in the correct folder or use -o <path>.',
      );
    }

    final type = context.vars['type'] as String;

    final isValid = BlocType.values.map((e) => e.value).contains(type);

    if (!isValid) {
      throw Exception('$type is not a valid type');
    }

    context.vars = {
      ...context.vars,
      'isTypeBloc': type == BlocType.bloc.value,
      'isTypeCubit': type == BlocType.cubit.value,
    };

  } catch (e) {
    context.logger.err('Generation Aborted: $e');
    exit(1);
  }
}
