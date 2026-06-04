import 'package:injectable/injectable.dart';
import 'package:urflutter_core/core/api/base/base_service.dart';
import 'package:urflutter_core/core/api/dio/dio_client.dart';
import 'package:urflutter_core/core/typedef/typedef.dart';

part 'do_something.dart';

@lazySingleton
// ignore: one_member_abstracts
abstract class {{name.pascalCase()}}ApiServices {
  @factoryMethod
  factory {{name.pascalCase()}}ApiServices(DioClient dioClient) =
      _{{name.pascalCase()}}ApiServicesImpl;

  ResultFeature<Object> doSomething();
}

class _{{name.pascalCase()}}ApiServicesImpl implements {{name.pascalCase()}}ApiServices {
  _{{name.pascalCase()}}ApiServicesImpl(this._dioClient);
  final DioClient _dioClient;

  @override
  ResultFeature<Object> doSomething() =>
      _doSomething(_dioClient);
}
