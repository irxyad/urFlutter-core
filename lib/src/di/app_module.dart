import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:urflutter_core/src/api/api.dart';
import 'package:urflutter_core/src/urflutter_config.dart';

@module
abstract class AppModule {
  @preResolve
  @lazySingleton
  Future<SharedPreferences> get sharedPreferences =>
      SharedPreferences.getInstance();

  @lazySingleton
  ApiConfig get apiConfig => UrFlutterConfig.apiConfig;

  @lazySingleton
  Dio dio(ApiConfig config) => ApiClient.create(
    config: config,
    authInterceptor: UrFlutterConfig.tokenProvider != null
        ? AuthInterceptor(
            tokenProvider: UrFlutterConfig.tokenProvider!,
            excludePaths: config.excludeTokenPaths,
            tokenPrefix: config.tokenPrefix,
          )
        : null,
    tokenRefreshInterceptorBuilder:
        UrFlutterConfig.onRefreshToken != null &&
            UrFlutterConfig.onRefreshFailed != null
        ? (dio) => TokenRefreshInterceptor(
            dio: dio,
            onRefreshToken: UrFlutterConfig.onRefreshToken!,
            onRefreshFailed: UrFlutterConfig.onRefreshFailed!,
            refreshPath: config.refreshPath,
            excludePaths: config.excludeRefreshTokenPaths,
            tokenPrefix: config.tokenPrefix,
          )
        : null,
    extraInterceptors: UrFlutterConfig.extraInterceptors,
  );
}
