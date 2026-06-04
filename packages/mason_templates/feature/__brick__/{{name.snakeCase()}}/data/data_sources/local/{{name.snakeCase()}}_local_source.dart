import 'package:injectable/injectable.dart';

part 'do_something.dart';

@lazySingleton
// ignore: one_member_abstracts
abstract class {{name.pascalCase()}}LocalServices {
  @factoryMethod
  factory {{name.pascalCase()}}LocalServices() =
      _{{name.pascalCase()}}LocalServicesImpl;

  Future<Object> doSomething();
}

class _{{name.pascalCase()}}LocalServicesImpl implements {{name.pascalCase()}}LocalServices {
  _{{name.pascalCase()}}LocalServicesImpl();

  @override
  Future<Object> doSomething() => _doSomething();
}
