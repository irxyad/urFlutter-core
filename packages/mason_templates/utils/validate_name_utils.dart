import 'package:mason/mason.dart';

/// Validasi nama fitur
void validateName(HookContext context) {
  final name = (context.vars['name'] as String).trim();

  if (name.isEmpty) {
    throw Exception('Name cannot be empty!');
  }

  if (name.contains(' ')) {
    throw Exception('Name cannot contain spaces!, use snake_case instead.');
  }

  context.vars = {...context.vars, 'name': name};
}
