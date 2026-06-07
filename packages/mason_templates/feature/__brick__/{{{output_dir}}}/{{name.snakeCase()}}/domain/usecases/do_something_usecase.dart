import 'package:injectable/injectable.dart';

import '../entities/{{name.snakeCase()}}_entity.dart';
import '../repositories/{{name.snakeCase()}}_repository.dart';
import 'package:urflutter_core/core/usecase/base_usecase.dart';
import 'package:urflutter_core/core/api/api.dart';


@injectable
class Get{{name.pascalCase()}}UseCase extends UseCase<{{name.pascalCase()}}Entity, String> {
  final {{name.pascalCase()}}Repository _repository;
  const Get{{name.pascalCase()}}UseCase(this._repository);

  @override
  Future<ApiResult<{{name.pascalCase()}}Entity>> call(String id) => _repository.get{{name.pascalCase()}}(id);
}
