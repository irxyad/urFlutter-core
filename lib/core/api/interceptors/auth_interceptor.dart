import 'package:dio/dio.dart';

import '../../logging/src/app_logger.dart';

class AuthInterceptor extends Interceptor {
  final Future<String?> Function() tokenProvider;
  final String authHeaderKey;
  final String tokenPrefix;

  AuthInterceptor({
    required this.tokenProvider,
    this.authHeaderKey = 'Authorization',
    this.tokenPrefix = 'Bearer',
  });

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    try {
      final token = await tokenProvider();

      if (token != null && token.isNotEmpty) {
        options.headers[authHeaderKey] = '$tokenPrefix $token';
        AppLogger.d(
          'Auth Interceptor',
          'Token added to request: ${options.path}',
        );
      }

      handler.next(options);
    } catch (e) {
      AppLogger.d('Auth Interceptor', 'Error adding token: $e');
      handler.next(options);
    }
  }
}
