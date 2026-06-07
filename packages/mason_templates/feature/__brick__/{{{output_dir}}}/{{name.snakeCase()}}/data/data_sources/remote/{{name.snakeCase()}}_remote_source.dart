import 'package:injectable/injectable.dart';
import 'package:urflutter_core/core/api/api.dart';

import '../../models/{{name.snakeCase()}}_model.dart';

// ignore: one_member_abstracts
abstract interface class {{name.pascalCase()}}RemoteDataSource {
  Future<ApiResult<{{name.pascalCase()}}Model>> get{{name.pascalCase()}}(String id);
}

@LazySingleton(as: {{name.pascalCase()}}RemoteDataSource)
class {{name.pascalCase()}}RemoteDataSourceImpl extends BaseApiService
    implements {{name.pascalCase()}}RemoteDataSource {
  {{name.pascalCase()}}RemoteDataSourceImpl(super.dio);

  @override
  Future<ApiResult<{{name.pascalCase()}}Model>> get{{name.pascalCase()}}(String id) => get(
    path: '/{{name.pascalCase()}}/$id',
    fromJson: {{name.pascalCase()}}Model.fromJson,
  );
}
