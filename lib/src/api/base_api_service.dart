import 'package:dio/dio.dart';

import 'handler/error_handler.dart';
import 'handler/response_handler.dart';
import 'models/api_result.dart';

/// Contoh:
/// ```dart
/// class UserService extends BaseApiService {
///   UserService(super.dio);
///
///   Future<ApiResult<User>> getUser(String id) {
///     return get(
///       path: '/users/$id',
///       fromJson: (data) => User.fromJson(data as Map<String, dynamic>),
///     );
///   }
///
///   Future<ApiResult<List<User>>> getUsers() {
///     return get(
///       path: '/users',
///       fromJson: (data) => (data as List)
///           .map((e) => User.fromJson(e as Map<String, dynamic>))
///           .toList(),
///     );
///   }
/// }
/// ```
abstract class BaseApiService {
  final Dio dio;

  const BaseApiService(this.dio);

  Future<ApiResult<T>> get<T>({
    required String path,
    bool useEnvelope = true,
    T Function(dynamic)? fromJson,
    Map<String, dynamic>? queryParameters,
    Options? options,
    void Function(int, int)? onReceiveProgress,
  }) => _execute(
    useEnvelope: useEnvelope,
    request: () => dio.get(
      path,
      queryParameters: queryParameters,
      options: options,
      onReceiveProgress: onReceiveProgress,
    ),
    fromJson: fromJson,
  );

  Future<ApiResult<T>> post<T>({
    required String path,
    bool useEnvelope = true,
    T Function(dynamic)? fromJson,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    void Function(int, int)? onReceiveProgress,
  }) => _execute(
    useEnvelope: useEnvelope,
    request: () => dio.post(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      onReceiveProgress: onReceiveProgress,
    ),
    fromJson: fromJson,
  );

  Future<ApiResult<T>> put<T>({
    required String path,
    bool useEnvelope = true,
    T Function(dynamic)? fromJson,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    void Function(int, int)? onReceiveProgress,
  }) => _execute(
    useEnvelope: useEnvelope,
    request: () => dio.put(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      onReceiveProgress: onReceiveProgress,
    ),
    fromJson: fromJson,
  );

  Future<ApiResult<T>> patch<T>({
    required String path,
    bool useEnvelope = true,
    T Function(dynamic)? fromJson,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    void Function(int, int)? onReceiveProgress,
  }) => _execute(
    useEnvelope: useEnvelope,
    request: () => dio.patch(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      onReceiveProgress: onReceiveProgress,
    ),
    fromJson: fromJson,
  );

  Future<ApiResult<T>> delete<T>({
    required String path,
    bool useEnvelope = true,
    T Function(dynamic)? fromJson,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) => _execute(
    useEnvelope: useEnvelope,
    request: () => dio.delete(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    ),
    fromJson: fromJson,
  );

  Future<ApiResult<T>> upload<T>({
    required String path,
    required FormData formData,
    bool useEnvelope = true,
    T Function(dynamic)? fromJson,
    void Function(int sent, int total)? onSendProgress,
  }) => _execute(
    useEnvelope: useEnvelope,
    request: () =>
        dio.post(path, data: formData, onSendProgress: onSendProgress),
    fromJson: fromJson,
  );

  Future<ApiResult<T>> download<T>({
    required String path,
    required String savePath,
    void Function(int, int)? onReceiveProgress,
  }) => _execute(
    useEnvelope: false,
    request: () =>
        dio.download(path, savePath, onReceiveProgress: onReceiveProgress),
  );

  Future<ApiResult<T>> _execute<T>({
    required Future<Response<dynamic>> Function() request,
    required bool useEnvelope,
    T Function(dynamic)? fromJson,
  }) async {
    try {
      final response = await request();

      return ResponseHandler.process<T>(
        response: response,
        fromJson: fromJson,
        useEnvelope: useEnvelope,
      );
    } catch (e) {
      return ErrorHandler.handle<T>(e);
    }
  }
}
