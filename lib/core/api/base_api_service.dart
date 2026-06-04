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
///       fromJson: User.fromJson,
///     );
///   }
/// }
/// ```
abstract class BaseApiService {
  final Dio dio;

  const BaseApiService(this.dio);

  /// GET request
  Future<ApiResult<T>> get<T>({
    required String path,
    required T Function(Map<String, dynamic>) fromJson,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) => _execute(
    request: () =>
        dio.get(path, queryParameters: queryParameters, options: options),
    fromJson: fromJson,
  );

  /// POST request
  Future<ApiResult<T>> post<T>({
    required String path,
    required T Function(Map<String, dynamic>) fromJson,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) => _execute(
    request: () => dio.post(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    ),
    fromJson: fromJson,
  );

  /// PUT request
  Future<ApiResult<T>> put<T>({
    required String path,
    required T Function(Map<String, dynamic>) fromJson,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) => _execute(
    request: () => dio.put(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    ),
    fromJson: fromJson,
  );

  /// PATCH request
  Future<ApiResult<T>> patch<T>({
    required String path,
    required T Function(Map<String, dynamic>) fromJson,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) => _execute(
    request: () => dio.patch(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    ),
    fromJson: fromJson,
  );

  /// DELETE request
  Future<ApiResult<T>> delete<T>({
    required String path,
    required T Function(Map<String, dynamic>) fromJson,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) => _execute(
    request: () => dio.delete(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    ),
    fromJson: fromJson,
  );

  /// Upload multipart/form-data
  Future<ApiResult<T>> upload<T>({
    required String path,
    required FormData formData,
    required T Function(Map<String, dynamic>) fromJson,
    void Function(int sent, int total)? onSendProgress,
  }) => _execute(
    request: () =>
        dio.post(path, data: formData, onSendProgress: onSendProgress),
    fromJson: fromJson,
  );

  Future<ApiResult<T>> _execute<T>({
    required Future<Response<dynamic>> Function() request,
    T Function(Map<String, dynamic>)? fromJson,
  }) async {
    try {
      final response = await request();
      return ResponseHandler.process<T>(response: response, fromJson: fromJson);
    } catch (e) {
      return ErrorHandler.handle<T>(e);
    }
  }
}
