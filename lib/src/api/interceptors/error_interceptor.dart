import 'package:dio/dio.dart';
import 'package:urflutter_core/src/logging/logging.dart';

import '../handler/auth_handler.dart';

class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    AppLogger.e(
      'Error Interceptor',
      message: 'Error intercepted: ${err.response?.statusCode}',
    );

    if (err.response?.statusCode == 401) {
      AppLogger.e(
        'Error Interceptor',
        message: 'Unauthorized - handling auth error',
      );

      await AuthHandler.instance.handleUnauthorized();
    } else if (err.response?.statusCode == 403) {
      AppLogger.e('Error Interceptor', message: 'Forbidden access');
    } else if (err.response?.statusCode == 404) {
      AppLogger.e('Error Interceptor', message: 'Resource not found');
    } else if (err.response?.statusCode == 500) {
      AppLogger.e('Error Interceptor', message: 'Server error');
    } else if (err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.receiveTimeout) {
      AppLogger.e('Error Interceptor', message: 'Timeout error');
    } else if (err.type == DioExceptionType.connectionError) {
      AppLogger.e('Error Interceptor', message: 'Connection error');
    }

    handler.next(err);
  }
}
