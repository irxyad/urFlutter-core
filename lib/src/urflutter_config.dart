import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:urflutter_core/src/api/api.dart';
import 'package:urflutter_core/src/logging/logging.dart';
import 'package:urflutter_core/src/widgets/loading/loading.dart';

class UrFlutterConfig {
  UrFlutterConfig._();

  static bool _initialized = false;

  static late ApiConfig _apiConfig;
  static late LogConfig _logConfig;
  static Future<String?> Function()? tokenProvider;
  static Future<String?> Function()? onRefreshToken;
  static Future<void> Function()? onRefreshFailed;

  static List<Interceptor> extraInterceptors = const [];

  static ApiConfig get apiConfig {
    _assertInitialized();
    return _apiConfig;
  }

  static LogConfig get logConfig {
    _assertInitialized();
    return _logConfig;
  }

  /// Wajib dipanggil sekali sebelum [configureDependencies].
  ///
  /// ```dart
  /// await UrFlutterConfig.setup(
  ///   apiConfig: ApiConfig.dev(baseUrl: 'https://api.example.com'),
  ///   tokenProvider: () async => await storage.read('access_token'),
  ///   onRefreshToken: () async {
  ///     final refreshToken = await storage.read('refresh_token');
  ///     if (refreshToken == null) return null;
  ///     final res = await refreshDio.post('/auth/refresh', data: {
  ///       'refreshToken': refreshToken,
  ///     });
  ///     final newAccessToken = res.data['accessToken'];
  ///     await storage.write('access_token', newAccessToken);
  ///     return newAccessToken;
  ///   },
  ///   onRefreshFailed: () async {
  ///     await storage.clear();
  ///     navigatorKey.currentState?.pushNamedAndRemoveUntil('/login', (_) => false);
  ///   },
  /// );
  /// ```
  static void setup({
    required ApiConfig apiConfig,
    required GlobalKey<NavigatorState> navigatorKey,
    LogConfig? logConfig,
    Future<String?> Function()? tokenProvider,
    Future<String?> Function()? onRefreshToken,
    Future<void> Function()? onRefreshFailed,
    ApiEnvelopeParser? envelopeParser,
    List<Interceptor> extraInterceptors = const [],
  }) {
    assert(!_initialized, 'UrFlutterConfig.setup() is already initialized.');
    assert(
      (onRefreshToken == null) == (onRefreshFailed == null),
      'onRefreshToken and onRefreshFailed must be provided together.',
    );

    _apiConfig = apiConfig;
    _logConfig =
        logConfig ??
        LogConfig(
          printer: SimpleLogPrinter(loggerName: 'UrFlutter'),
          output: ConsoleOutput(),
          level: kReleaseMode ? Level.off : Level.all,
        );

    if (envelopeParser != null) {
      ResponseHandler.configure(parser: envelopeParser);
    }

    UrFlutterConfig.extraInterceptors = extraInterceptors;
    UrFlutterConfig.tokenProvider = tokenProvider;
    UrFlutterConfig.onRefreshToken = onRefreshToken;
    UrFlutterConfig.onRefreshFailed = onRefreshFailed;
    AppLogger.initialize(_logConfig);
    AppLoading.initialize(navigatorKey);

    _initialized = true;
  }

  static void _assertInitialized() {
    assert(_initialized, 'UrFlutterConfig.setup() is not initialized.');
  }
}
