import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

import '../constants/log_colors.dart';
import '../constants/log_emojis.dart';
import '../constants/log_styles.dart';

class DioRequestFormatter {
  static List<String> format(RequestOptions request, String loggerName) {
    final lines = <String>[];

    // Header
    final emoji = LogEmojis.getMethodEmoji(request.method);
    final header = LogStyles.header('REQUEST', emoji: emoji);
    final method = LogStyles.bracket(
      request.method.toUpperCase(),
      textColor: LogColors.methodColor,
    );
    final url = LogColors.urlColor(request.uri.toString());

    lines.add('$header $method $url');

    if (request.headers.isNotEmpty) {
      lines.add(LogStyles.header('HEADERS', emoji: '📋'));
      request.headers.forEach((key, value) {
        lines.add('  ${LogStyles.keyValue(key, value)}');
      });
    }

    // Query Params
    if (request.queryParameters.isNotEmpty) {
      lines.add(LogStyles.header('QUERY', emoji: '🔍'));
      request.queryParameters.forEach((key, value) {
        lines.add('  ${LogStyles.keyValue(key, value)}');
      });
    }

    // Body
    if (request.data != null) {
      lines.add(LogStyles.header('DATA', emoji: '📦'));
      if (request.data is FormData) {
        final formData = request.data as FormData;
        for (final field in formData.fields) {
          lines.add('  ${LogStyles.keyValue(field.key, field.value)}');
        }
      } else {
        lines.add('  ${LogColors.noColor(request.data.toString())}');
      }
    }

    return lines;
  }
}

class DioResponseFormatter {
  static List<String> format(Response<dynamic> response, String loggerName) {
    final lines = <String>[];

    final statusCode = response.statusCode ?? 0;
    final statusColor = LogColors.getStatusCodeColor(statusCode);
    final statusText = statusColor(statusCode.toString());

    // Header
    final header = LogStyles.header(statusText, emoji: LogEmojis.response);
    final method = LogStyles.bracket(
      response.requestOptions.method.toUpperCase(),
      textColor: LogColors.methodColor,
    );
    final url = LogColors.urlColor(response.realUri.toString());

    lines.add('$header $method $url');

    // Status Message
    if (response.statusMessage != null) {
      lines.add(
        '${LogStyles.header('MESSAGE', emoji: '💬')} ${LogColors.noColor(response.statusMessage!)}',
      );
    }

    // Respon Data
    if (response.data != null) {
      lines.add(LogStyles.header('DATA', emoji: '📦'));
      final dataStr = response.data.toString();
      if (dataStr.length > 500) {
        lines.add('  ${LogColors.noColor('${dataStr.substring(0, 500)}...')}');
      } else {
        lines.add('  ${LogColors.noColor(dataStr)}');
      }
    }

    return lines;
  }
}

class DioErrorFormatter {
  static List<String> format(DioException error, String loggerName) {
    final lines = <String>[];

    // Header
    final header = LogStyles.header('ERROR', emoji: LogEmojis.error);
    final method = LogStyles.bracket(
      error.requestOptions.method.toUpperCase(),
      textColor: LogColors.methodColor,
    );
    final url = LogColors.urlColor(error.requestOptions.uri.toString());

    lines.add('$header $method $url');

    // Error Type
    lines.add(
      '${LogStyles.header('TYPE', emoji: '🏷️')} ${LogColors.noColor(error.type.toString())}',
    );

    // Error Message
    if (error.message != null) {
      lines.add(
        '${LogStyles.header('MESSAGE', emoji: '💬')} ${LogColors.levelColors[Level.error]!(error.message!)}',
      );
    }

    // Response Error
    if (error.response != null) {
      final statusCode = error.response!.statusCode ?? 0;
      final statusColor = LogColors.getStatusCodeColor(statusCode);

      lines.add(
        '${LogStyles.header('STATUS', emoji: '📊')} ${statusColor(statusCode.toString())}',
      );

      if (error.response!.data != null) {
        lines.add(LogStyles.header('DETAIL', emoji: '📋'));
        final errorData = error.response!.data.toString();
        if (errorData.length > 300) {
          lines.add(
            '  ${LogColors.levelColors[Level.error]!('${errorData.substring(0, 300)}...')}',
          );
        } else {
          lines.add('  ${LogColors.levelColors[Level.error]!(errorData)}');
        }
      }
    }

    lines.add(LogStyles.header('STACK', emoji: '📚'));
    final stackLines = error.stackTrace.toString().split('\n').take(5);
    for (final line in stackLines) {
      lines.add('  ${LogColors.noColor(line)}');
    }

    return lines;
  }
}
