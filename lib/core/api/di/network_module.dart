import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import '../interceptors/auth_interceptor.dart';
import '../interceptors/token_refresh_interceptor.dart';
import '../network/api_client.dart';
import '../network/api_config.dart';

/// Setup:
/// ```dart
/// NetworkModule.register(
///   config: ApiConfig.prod(baseUrl: Env.apiUrl),
///   tokenProvider: () => SecureStorage.getToken(),
///   onRefreshToken: () => AuthService.refresh(),
///   onRefreshFailed: () => AuthCubit.logout(),
///   refreshPath: '/auth/refresh',   // sesuaikan dengan endpoint refresh kamu
/// );
/// ```
class NetworkModule {
  NetworkModule._();

  static const String defaultDioName = 'default_dio';

  static final _getIt = GetIt.instance;

  static void register({
    required ApiConfig config,
    Future<String?> Function()? tokenProvider,
    Future<String?> Function()? onRefreshToken,
    Future<void> Function()? onRefreshFailed,
    String refreshPath = '/auth/refresh',
    List<Interceptor> extraInterceptors = const [],
    String instanceName = defaultDioName,
  }) {
    if (!_getIt.isRegistered<ApiConfig>(instanceName: instanceName)) {
      _getIt.registerSingleton<ApiConfig>(config, instanceName: instanceName);
    }

    AuthInterceptor? authInterceptor;
    if (tokenProvider != null) {
      authInterceptor = AuthInterceptor(tokenProvider: tokenProvider);
    }

    if (!_getIt.isRegistered<Dio>(instanceName: instanceName)) {
      final dio = ApiClient.create(
        config: config,
        authInterceptor: authInterceptor,
        extraInterceptors: extraInterceptors,
      );

      if (onRefreshToken != null && onRefreshFailed != null) {
        dio.interceptors.add(
          TokenRefreshInterceptor(
            dio: dio,
            onRefreshToken: onRefreshToken,
            onRefreshFailed: onRefreshFailed,
            refreshPath: refreshPath,
          ),
        );
      }

      _getIt.registerSingleton<Dio>(
        dio,
        instanceName: instanceName,
        dispose: (d) => d.close(),
      );
    }
  }

  static Dio getDio([String instanceName = defaultDioName]) {
    return _getIt<Dio>(instanceName: instanceName);
  }

  static ApiConfig getConfig([String instanceName = defaultDioName]) {
    return _getIt<ApiConfig>(instanceName: instanceName);
  }
}
