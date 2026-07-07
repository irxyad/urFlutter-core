import 'package:dio/dio.dart';
import 'package:urflutter_core/src/logging/logging.dart';
import 'package:urflutter_core/src/shared/shared.dart';

class AuthInterceptor extends Interceptor {
  final Future<String?> Function() tokenProvider;
  final String authHeaderKey;
  final String? tokenPrefix;
  final List<String> excludePaths;

  AuthInterceptor({
    required this.tokenProvider,
    required this.excludePaths,
    this.authHeaderKey = 'Authorization',
    this.tokenPrefix,
  });

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (excludePaths.contains(options.path)) {
      handler.next(options);
      return;
    }

    try {
      final token = await tokenProvider();

      if (token != null && token.isNotEmpty) {
        options.headers[authHeaderKey] =
            '${tokenPrefix ?? AppConstants.dTokenPrefix} $token';
        AppLogger.d(
          'Auth Interceptor',
          message: 'Token added to request: ${options.path}',
        );
      }

      handler.next(options);
    } catch (e) {
      AppLogger.d('Auth Interceptor', message: 'Error adding token: $e');
      handler.next(options);
    }
  }
}
