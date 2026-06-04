import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

import 'models/log_config.dart';
import 'models/log_message.dart';
import 'printers/simple_log_printer.dart';

/// Contoh:
/// ```dart
/// AppLogger.i('This is info');
/// AppLogger.e('API', 'This is error from API');
/// ```
///
/// Contoh di Dio :
///
/// ```dart
/// dio = Dio(BaseOptions(baseUrl: 'https://api.example.com'));
/// dio.addLogger(loggerName: 'API');
/// ```
///
/// ```dart
/// AppLogger.dioReq(request);
/// AppLogger.dioRes(response);
/// AppLogger.dioError(error);

abstract class AppLogger {
  static Logger? _logger;
  static LogConfig? _config;

  /// **Initialize notification manager di root widget**
  /// ``` dart
  ///   AppLogger.initialize(
  ///   LogConfig(
  ///     defaultLoggerName: 'MyApp',
  ///     level: Level.all,
  ///     printer: SimpleLogPrinter(
  ///       loggerName: 'MyApp',
  ///       showTime: true,
  ///       showEmoji: true,
  ///     ),
  ///     output: ConsoleOutput(),
  ///   ),
  /// );
  /// ```
  static void initialize([LogConfig? config]) {
    _config =
        config ??
        LogConfig(
          printer: SimpleLogPrinter(loggerName: 'AppLogger'),
          output: ConsoleOutput(),
          level: kReleaseMode ? Level.off : Level.all,
        );

    _logger = Logger(
      printer: _config!.printer,
      level: _config!.level,
      output: _config!.output,
      filter: _config!.filter,
    );
  }

  static void _log(Level level, dynamic message, [String? customName]) {
    assert(_logger != null, '''
Logger not initialized.

Please initialize AppLogger in the root widget.

Example:

AppLogger.initialize(
  LogConfig(
    defaultLoggerName: 'MyApp',
    level: Level.all,
    printer: SimpleLogPrinter(
      loggerName: 'MyApp',
      showTime: true,
      showEmoji: true,
    ),
    output: ConsoleOutput(),
  ),
);
''');

    final logMessage = customName != null
        ? LogMessage(message, customName)
        : message;
    _logger!.log(level, logMessage);
  }

  /// Log info
  static void i([String? loggerNameOrMessage, String? message]) {
    if (message == null) {
      _log(Level.info, loggerNameOrMessage);
    } else {
      _log(Level.info, message, loggerNameOrMessage);
    }
  }

  /// Log error
  static void e([String? loggerNameOrMessage, String? message]) {
    if (message == null) {
      _log(Level.error, loggerNameOrMessage);
    } else {
      _log(Level.error, message, loggerNameOrMessage);
    }
  }

  /// Log warning
  static void w([String? loggerNameOrMessage, String? message]) {
    if (message == null) {
      _log(Level.warning, loggerNameOrMessage);
    } else {
      _log(Level.warning, message, loggerNameOrMessage);
    }
  }

  /// Log debug
  static void d([String? loggerNameOrMessage, String? message]) {
    if (message == null) {
      _log(Level.debug, loggerNameOrMessage);
    } else {
      _log(Level.debug, message, loggerNameOrMessage);
    }
  }

  /// Log fatal
  static void f([String? loggerNameOrMessage, String? message]) {
    if (message == null) {
      _log(Level.fatal, loggerNameOrMessage);
    } else {
      _log(Level.fatal, message, loggerNameOrMessage);
    }
  }

  /// Log trace
  static void t([String? loggerNameOrMessage, String? message]) {
    if (message == null) {
      _log(Level.trace, loggerNameOrMessage);
    } else {
      _log(Level.trace, message, loggerNameOrMessage);
    }
  }

  /// Log Dio error
  static void dioError(DioException error, [String? loggerName]) {
    _log(Level.error, error, loggerName);
  }

  /// Log Dio request
  static void dioReq(RequestOptions request, [String? loggerName]) {
    _log(Level.info, request, loggerName);
  }

  /// Log Dio response
  static void dioRes(Response<dynamic> response, [String? loggerName]) {
    _log(Level.info, response, loggerName);
  }

  static void close() {
    _logger?.close();
    _logger = null;
    _config = null;
  }

  static void updateConfig(LogConfig config) {
    _config = config;
    _logger = Logger(
      printer: config.printer,
      level: config.level,
      output: config.output,
      filter: config.filter,
    );
  }
}

/// Extension untuk Dio
extension DioLoggingExtension on Dio {
  void addLogger({String? loggerName}) {
    interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          AppLogger.dioReq(options, loggerName);
          handler.next(options);
        },
        onResponse: (response, handler) {
          AppLogger.dioRes(response, loggerName);
          handler.next(response);
        },
        onError: (error, handler) {
          AppLogger.dioError(error, loggerName);
          handler.next(error);
        },
      ),
    );
  }
}
