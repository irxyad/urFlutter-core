import 'package:dio/dio.dart';

import '../interceptors/auth_interceptor.dart';
import '../interceptors/logging_interceptor.dart';
import 'api_config.dart';

class ApiClient {
  ApiClient._();

  /// [authInterceptor] - opsional, tambahkan kalau endpoint butuh auth
  /// [extraInterceptors] - interceptor tambahan sesuai kebutuhan
  static Dio create({
    required ApiConfig config,
    AuthInterceptor? authInterceptor,
    List<Interceptor> extraInterceptors = const [],
  }) {
    final dio = Dio(
      BaseOptions(
        baseUrl: config.baseUrl,
        connectTimeout: config.connectTimeout,
        receiveTimeout: config.receiveTimeout,
        sendTimeout: config.sendTimeout,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          ...config.defaultHeaders,
        },
      ),
    );

    if (config.enableLogging) {
      dio.interceptors.add(LoggingInterceptor());
    }

    // Auth interceptor (inject token)
    if (authInterceptor != null) {
      dio.interceptors.add(authInterceptor);
    }

    // Interceptor tambahan dari luar
    dio.interceptors.addAll(extraInterceptors);

    return dio;
  }
}
