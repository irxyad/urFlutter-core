import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';

import '../constants/log_colors.dart';
import '../constants/log_emojis.dart';
import '../constants/log_styles.dart';
import '../formatters/dio_formatter.dart';
import '../models/log_message.dart';

class SimpleLogPrinter extends LogPrinter {
  final String loggerName;
  final bool showTime;
  final bool showEmoji;
  final bool showStackTrace;
  final int methodCount;
  final int errorMethodCount;
  final DateFormat? dateTimeFormat;

  SimpleLogPrinter({
    required this.loggerName,
    this.showTime = true,
    this.showEmoji = true,
    this.showStackTrace = false,
    this.methodCount = 2,
    this.errorMethodCount = 8,
    DateFormat? dateTimeFormat,
  }) : dateTimeFormat = dateTimeFormat ?? DateFormat('HH:mm:ss.SSS');

  @override
  List<String> log(LogEvent event) {
    var currentLoggerName = loggerName;
    dynamic actualMessage = event.message;

    if (event.message is LogMessage) {
      final logMsg = event.message as LogMessage;
      currentLoggerName = logMsg.loggerName;
      actualMessage = logMsg.message;
    }

    final prefix = _buildPrefix(event, currentLoggerName);

    if (actualMessage is Response) {
      return _formatResponse(prefix, actualMessage, currentLoggerName);
    } else if (actualMessage is RequestOptions) {
      return _formatRequest(prefix, actualMessage, currentLoggerName);
    } else if (actualMessage is DioException) {
      return _formatError(prefix, actualMessage, currentLoggerName);
    }

    return _formatDefault(prefix, event, actualMessage);
  }

  String _buildPrefix(LogEvent event, String currentLoggerName) {
    final parts = <String>[];

    parts.add(LogColors.nameColor('[$currentLoggerName]'));

    if (showTime) {
      final time = dateTimeFormat!.format(event.time);
      parts.add(LogColors.timestampColor(time));
    }

    if (showEmoji) {
      parts.add(LogEmojis.levelEmojis[event.level]!);
    }

    final color = LogColors.levelColors[event.level]!;
    final levelName = _getLevelName(event.level);
    parts.add(LogStyles.levelName(event.level, color, levelName));

    return parts.join(' ');
  }

  List<String> _formatResponse(
    String prefix,
    Response<dynamic> response,
    String loggerName,
  ) {
    final formatted = DioResponseFormatter.format(response, loggerName);
    return formatted.map((line) => '$prefix $line').toList();
  }

  List<String> _formatRequest(
    String prefix,
    RequestOptions request,
    String loggerName,
  ) {
    final formatted = DioRequestFormatter.format(request, loggerName);
    return formatted.map((line) => '$prefix $line').toList();
  }

  List<String> _formatError(
    String prefix,
    DioException error,
    String loggerName,
  ) {
    final formatted = DioErrorFormatter.format(error, loggerName);
    return formatted.map((line) => '$prefix $line').toList();
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
