import 'package:injectable/injectable.dart';
import 'package:urflutter_core/core/typedef/typedef.dart';
import 'package:urflutter_core/core/usecase/usecase.dart';

@lazySingleton
class DoSomethingUsecase extends UseCaseWithoutRequest {
  DoSomethingUsecase(this.repository);
  final {{name.pascalCase()}}Repository repository;

  @override
  ResultFeature<Object> call() => repository.doSomething();
}
