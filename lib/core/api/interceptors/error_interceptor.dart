import 'package:dio/dio.dart';

import '../../logging/logging.dart';
import '../handler/auth_handler.dart';

class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    AppLogger.e(
      'Error Interceptor',
      'Error intercepted: ${err.response?.statusCode}',
    );

    if (err.response?.statusCode == 401) {
      AppLogger.e('Error Interceptor', 'Unauthorized - handling auth error');

      await AuthHandler.instance.handleUnauthorized();
    } else if (err.response?.statusCode == 403) {
      AppLogger.e('Error Interceptor', 'Forbidden access');
    } else if (err.response?.statusCode == 404) {
      AppLogger.e('Error Interceptor', 'Resource not found');
    } else if (err.response?.statusCode == 500) {
      AppLogger.e('Error Interceptor', 'Server error');
    } else if (err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.receiveTimeout) {
      AppLogger.e('Error Interceptor', 'Timeout error');
    } else if (err.type == DioExceptionType.connectionError) {
      AppLogger.e('Error Interceptor', 'Connection error');
    }

    handler.next(err);
  }
}
