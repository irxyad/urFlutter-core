import 'package:mason/mason.dart';

enum BlocType {
  bloc('bloc'),
  cubit('cubit');

  final String value;

  const BlocType(this.value);

  static BlocType fromString(String value) {
    return BlocType.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw Exception('$value is not a valid BlocType'),
    );
  }

  @override
  String toString() => value;
}

/// Ngeset apakah akan generate bloc atau cubit
BlocType resolveBlocType(HookContext context) {
  final rawType = context.vars['bloc_type'] as String?;

  if (rawType != null) {
    return BlocType.fromString(rawType);
  }

  return context.logger.chooseOne(
    'Select the state management type',
    choices: BlocType.values,
    defaultValue: BlocType.bloc,
    display: (choice) => choice.value,
  );
}
