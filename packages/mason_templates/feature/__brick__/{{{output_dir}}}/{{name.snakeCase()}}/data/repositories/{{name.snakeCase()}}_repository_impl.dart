import 'package:injectable/injectable.dart';

import '../../domain/entities/{{name.snakeCase()}}_entity.dart';
import '../../domain/repositories/{{name.snakeCase()}}_repository.dart';
import '../data_sources/local/{{name.snakeCase()}}_local_source.dart';
import '../data_sources/remote/{{name.snakeCase()}}_remote_source.dart';
import 'package:urflutter_core/core/api/api.dart';

@LazySingleton(as: {{name.pascalCase()}}Repository)
class {{name.pascalCase()}}RepositoryImpl implements {{name.pascalCase()}}Repository {
  final {{name.pascalCase()}}RemoteDataSource _remote;
  // ignore: unused_field
  final {{name.pascalCase()}}LocalDataSource _local;

  const {{name.pascalCase()}}RepositoryImpl(this._remote, this._local);

  @override
  Future<ApiResult<{{name.pascalCase()}}Entity>> get{{name.pascalCase()}}(String id) async {
  final result = await _remote.get{{name.pascalCase()}}(id);

  return result.map((model) => model.toEntity());
}

}