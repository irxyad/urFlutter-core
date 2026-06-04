part of '{{name.snakeCase()}}_remote_source.dart';

ResultFeature<Object> _doSomething(DioClient dioClient) async {
  return BaseService.get(
    dio: dioClient.instance,
    path: '', // Replace with your API endpoint
    parser: (val) {
      return val;
    },
  );
}
