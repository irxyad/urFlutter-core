import 'package:mason/mason.dart';

/// Validasi nama fitur
void validateName(HookContext context, {required String label, String? hint}) {
  final hintTxt = hint == null
      ? ''
      : ' ${darkGray.wrap('(without bloc/cubit suffix)') ?? ''}';

  while (true) {
    final name = context.logger.prompt(label + hintTxt);

    if (name.trim().isEmpty) {
      context.logger.warn('Name cannot be empty.');
    } else if (name.contains(' ')) {
      context.logger.warn(
        'Name cannot contain spaces. Use snake_case instead.',
      );
    } else {
      context.vars = {...context.vars, 'name': name.trim()};
      break;
    }
  }
}
