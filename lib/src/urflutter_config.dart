import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:urflutter_core/src/api/api.dart';
import 'package:urflutter_core/src/configs/image.dart';
import 'package:urflutter_core/src/logging/logging.dart';
import 'package:urflutter_core/src/styles/colors.dart';
import 'package:urflutter_core/widgets.dart';

class UrFlutterConfig {
  UrFlutterConfig._();

  static bool _initialized = false;

  static late ApiConfig _apiConfig;
  static late UrAppColors _appColors;
  static late LogConfig _logConfig;
  static late ConfigurationImage _configurationImage;
  static late LoadingConfig _loadingConfig;
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

  static UrAppColors get appColors {
    _assertInitialized();
    return _appColors;
  }

  static ConfigurationImage get configurationImage {
    _assertInitialized();
    return _configurationImage;
  }

  static LoadingConfig get loadingConfig {
    _assertInitialized();
    return _loadingConfig;
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
    required UrAppColors appColors,
    required GlobalKey<NavigatorState> navigatorKey,
    LogConfig? logConfig,
    ConfigurationImage? configurationImage,
    LoadingConfig? loadingConfig,
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

    _loadingConfig =
        loadingConfig ??
        LoadingConfig(
          type: LoadingType.newtonCradle,
          message: 'Loading...',
          showMessage: true,
          minDuration: const Duration(milliseconds: 300),
        );

    if (envelopeParser != null) {
      ResponseHandler.configure(parser: envelopeParser);
    }

    UrFlutterConfig.extraInterceptors = extraInterceptors;
    UrFlutterConfig.tokenProvider = tokenProvider;
    UrFlutterConfig.onRefreshToken = onRefreshToken;
    UrFlutterConfig.onRefreshFailed = onRefreshFailed;
    AppLogger.initialize(_logConfig);
    UrLoading.initialize(navigatorKey, config: _loadingConfig);

    _appColors = appColors;
    _configurationImage = configurationImage ?? ConfigurationImage();

    _initialized = true;
  }

  static void _assertInitialized() {
    assert(_initialized, 'UrFlutterConfig.setup() is not initialized.');
  }
}
