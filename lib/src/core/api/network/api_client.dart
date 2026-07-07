import 'package:dio/dio.dart';

import '../interceptors/auth_interceptor.dart';
import '../interceptors/logging_interceptor.dart';
import 'api_config.dart';

typedef DioDependentInterceptorBuilder = Interceptor Function(Dio dio);

class ApiClient {
  ApiClient._();

  static Dio create({
    required ApiConfig config,
    AuthInterceptor? authInterceptor,
    DioDependentInterceptorBuilder? tokenRefreshInterceptorBuilder,
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

    if (tokenRefreshInterceptorBuilder != null) {
      dio.interceptors.add(tokenRefreshInterceptorBuilder(dio));
    }

    // Interceptor tambahan dari luar
    dio.interceptors.addAll(extraInterceptors);

    return dio;
  }
}
