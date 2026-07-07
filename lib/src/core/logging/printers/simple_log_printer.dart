import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';

import '../constants/log_colors.dart';
import '../constants/log_emojis.dart';
import '../constants/log_styles.dart';
import '../formatters/dio_formatter.dart';
import '../models/log_message.dart';

bool _defaultShowResponseData(String path) => true;

class SimpleLogPrinter extends LogPrinter {
  final String loggerName;
  final bool showTime;
  final bool showEmoji;
  final bool showStackTrace;

  /// Menampilkan response data, dengan melempar path jika ingin
  /// skip response data pada endpoint tertentu, misal
  /// `showResponseData: (path) => !path.contains('user')`
  /// maka response data pada endpoint `user` tidak akan ditampilkan
  final bool Function(String path) showResponseData;
  final int methodCount;
  final int errorMethodCount;
  final DateFormat? dateTimeFormat;

  SimpleLogPrinter({
    required this.loggerName,
    this.showTime = true,
    this.showEmoji = true,
    this.showStackTrace = false,
    this.showResponseData = _defaultShowResponseData,
    this.methodCount = 2,
    this.errorMethodCount = 8,
    DateFormat? dateTimeFormat,
  }) : dateTimeFormat = dateTimeFormat ?? DateFormat('HH:mm:ss.SSS');

  @override
  List<String> log(LogEvent event) {
    LogMessage log = event.message;
    var currentLoggerName = log.loggerName ?? loggerName;

    final prefix = _buildPrefix(
      event,
      currentLoggerName,
      showIndicator: log.showIndicator,
    );
    final prefixHttp = _buildPrefix(event, currentLoggerName, isHttp: true);

    if (log.message is Response) {
      return _formatResponse(prefixHttp, log.message);
    } else if (log.message is RequestOptions) {
      return _formatRequest(prefixHttp, log.message);
    } else if (log.message is DioException) {
      return _formatError(prefixHttp, log.message);
    }

    return _formatDefault(prefix, event, log.message);
  }

  String _buildPrefix(
    LogEvent event,
    String currentLoggerName, {
    bool isHttp = false,
    bool showIndicator = true,
  }) {
    final parts = <String>[];
    final loggerName = isHttp ? 'HTTP' : currentLoggerName;

    if (showTime) {
      final time = dateTimeFormat!.format(event.time);
      parts.add(LogColors.timestampColor(time));
    }

    parts.add(LogColors.nameColor('[$loggerName]'));

    if (!isHttp) {
      if (showIndicator && showEmoji) {
        parts.add(LogEmojis.levelEmojis[event.level]!);
      }
      if (showIndicator) {
        final color = LogColors.levelColors[event.level]!;
        final levelName = _getLevelName(event.level);
        parts.add(LogStyles.levelName(event.level, color, levelName));
      }
    }

    return parts.join(' ');
  }

  List<String> _formatResponse(String prefix, Response<dynamic> response) {
    final formatted = DioResponseFormatter.format(
      response,
      showResponseData(response.requestOptions.path),
    );
    return ['$prefix $formatted'];
  }

  List<String> _formatRequest(String prefix, RequestOptions request) {
    final formatted = DioRequestFormatter.format(request);
    return ['$prefix $formatted'];
  }

  List<String> _formatError(String prefix, DioException error) {
    final formatted = DioErrorFormatter.format(error);
    return ['$prefix $formatted'];
  }

  List<String> _formatDefault(String prefix, LogEvent event, dynamic message) {
    final lines = <String>['$prefix ${LogColors.noColor(message.toString())}'];

    if (event.error != null) {
      lines.add('${LogStyles.header('ERROR')} ${event.error}');
    }

    if (showStackTrace && event.stackTrace != null) {
      lines.add(LogStyles.header('STACK TRACE'));
      final stackLines = event.stackTrace.toString().split('\n');
      final count = event.level.index >= Level.error.index
          ? errorMethodCount
          : methodCount;
      lines.addAll(stackLines.take(count).map((line) => '  $line'));
    }

    return lines;
  }

  String _getLevelName(Level level) {
    switch (level) {
      case Level.trace:
        return 'TRACE';
      case Level.debug:
        return 'DEBUG';
      case Level.info:
        return 'INFO';
      case Level.warning:
        return 'WARNING';
      case Level.error:
        return 'ERROR';
      case Level.fatal:
        return 'FATAL';
      default:
        return level.toString();
    }
  }
}
