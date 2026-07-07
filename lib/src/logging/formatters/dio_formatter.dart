import 'package:dio/dio.dart';

import '../constants/log_colors.dart';
import '../constants/log_emojis.dart';
import '../constants/log_styles.dart';

String _method(String method) => LogStyles.noBracket(
  method.toUpperCase(),
  textColor: LogColors.getMethodColor(method),
);

String _details(String label, dynamic result) {
  final res = result
      .toString()
      .split('\n')
      .map((e) => e.endsWith('.') ? e.substring(0, e.length - 1) : e)
      .join('. ');
  return result == null || result == 'null'
      ? ''
      : LogStyles.bracket(label, textColor: LogColors.infoColor) +
            LogColors.noColor(' $res');
}

class DioRequestFormatter {
  static String format(RequestOptions request) {
    final emoji = LogEmojis.request;
    final statusLabel = ' REQ ';
    final title = LogStyles.bracket(statusLabel);
    final method = _method(request.method);
    final loading = LogStyles.bracket('∙∙∙', textColor: LogColors.nameColor);
    final url = LogColors.noColor(request.uri.toString());

    final body = request.data is FormData
        ? (request.data as FormData).fields.toString()
        : '${request.data}';
    final details = _details('BODY', body);

    return '$emoji $title $method $loading $url $details';
  }
}

class DioResponseFormatter {
  static String format(Response<dynamic> response, bool showResponseData) {
    final emoji = LogEmojis.response;
    final code = response.statusCode;
    final statusLabel = ' RES ';
    final statusBracket = LogStyles.bracket(
      statusLabel,
      textColor: LogColors.getStatusCodeColor(code ?? 500),
    );
    final method = _method(response.requestOptions.method);
    final statusCode = code == null
        ? ''
        : LogStyles.bracket(
            '$code',
            textColor: LogColors.getStatusCodeColor(code),
          );
    final url = LogColors.noColor(response.realUri.toString());
    final message = _details('MESSAGE', response.statusMessage);
    final res = !showResponseData ? '' : _details('DATA', response.data);

    return '$emoji $statusBracket $method $statusCode $url $message $res';
  }
}

class DioErrorFormatter {
  static String format(DioException error) {
    final options = error.requestOptions;
    final title = LogStyles.bracket(' ERR ', textColor: LogColors.errorColor);
    final emoji = LogEmojis.error;
    final method = _method(error.requestOptions.method);
    final code = error.response?.statusCode;
    final statusCode = code == null
        ? ''
        : LogStyles.bracket(
            '$code',
            textColor: LogColors.getStatusCodeColor(code),
          );
    final url = LogColors.noColor('${options.uri}');

    final message = _details('MESSAGE', error.response?.data);
    final detail = _details('DETAIL', error.error);

    return '$emoji $title $method $statusCode $url $message $detail ';
  }
}
