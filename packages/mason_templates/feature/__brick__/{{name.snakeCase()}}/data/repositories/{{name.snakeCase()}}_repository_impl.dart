import 'package:injectable/injectable.dart';
import 'package:urflutter_core/core/typedef/typedef.dart';
import '../../domain/repositories/{{name.snakeCase()}}_repository.dart';

@LazySingleton(as: {{name.pascalCase()}}Repository)
class {{name.pascalCase()}}RepositoryImpl extends {{name.pascalCase()}}Repository {
  {{name.pascalCase()}}RepositoryImpl(
    // this.myService
    );
  // Service injection
  // final MyService myService;

  @override
  ResultFeature<EntityHere> doSomething() async {
    // final res = await myService.doSomething();
    // return res.map((val) => val.toEntity());
  }
}
