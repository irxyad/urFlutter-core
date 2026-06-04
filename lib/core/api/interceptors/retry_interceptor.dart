import 'package:dio/dio.dart';

import '../../logging/logging.dart';

class RetryInterceptor extends Interceptor {
  final Dio dio;
  final int maxRetries;
  final Duration retryDelay;
  final List<int> retryStatusCodes;

  RetryInterceptor({
    required this.dio,
    this.maxRetries = 3,
    this.retryDelay = const Duration(seconds: 1),
    this.retryStatusCodes = const [408, 429, 500, 502, 503, 504],
  });

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final statusCode = err.response?.statusCode;

    if (_shouldRetry(err, statusCode)) {
      final retries = err.requestOptions.extra['retries'] ?? 0;

      if (retries < maxRetries) {
        AppLogger.d(
          'Retry Interceptor',
          'Retrying request (${retries + 1}/$maxRetries)',
        );

        await Future.delayed(retryDelay * (retries + 1));

        err.requestOptions.extra['retries'] = retries + 1;

        try {
          final response = await dio.fetch(err.requestOptions);
          handler.resolve(response);
          return;
        } catch (_) {}
      } else {
        AppLogger.d('Retry Interceptor', 'Max retries reached');
      }
    }

    handler.next(err);
  }

  bool _shouldRetry(DioException err, int? statusCode) {
    // Tidak perlu retry kalau 401 atau 403
    if (statusCode == 401 || statusCode == 403) {
      return false;
    }

    if (err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        err.type == DioExceptionType.sendTimeout ||
        err.type == DioExceptionType.connectionError) {
      return true;
    }

    if (statusCode != null && retryStatusCodes.contains(statusCode)) {
      return true;
    }

    return false;
  }
}
