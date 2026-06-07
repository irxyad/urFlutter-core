import 'dart:convert';

import 'package:injectable/injectable.dart';
import '../../models/{{name.snakeCase()}}_model.dart';
import 'package:urflutter_core/core/local/preferences_client.dart';

// ignore: one_member_abstracts
abstract interface class {{name.pascalCase()}}LocalDataSource {
  {{name.pascalCase()}}Model? get();
}

@LazySingleton(as: {{name.pascalCase()}}LocalDataSource)
class {{name.pascalCase()}}LocalDataSourceImpl implements {{name.pascalCase()}}LocalDataSource {
  const {{name.pascalCase()}}LocalDataSourceImpl(this._prefs);
  
  final PreferencesClient _prefs;

  @override
  {{name.pascalCase()}}Model? get() {
    final json = _prefs.getString('{{name.snakeCase()}}');

    if (json == null) return null;

    return {{name.pascalCase()}}Model.fromJson(jsonDecode(json) as Map<String, dynamic>);
  }
}
