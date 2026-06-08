import 'package:urflutter_core/core/api/api.dart';

import '../entities/{{name.snakeCase()}}_entity.dart';

// ignore: one_member_abstracts
abstract interface class {{name.pascalCase()}}void Repository {
  Future<ApiResult<{{name.pascalCase()}}Entity>> get{{name.pascalCase()}}(String id);
}