import 'package:logger/logger.dart';

import 'log_colors.dart';

class LogStyles {
  LogStyles._();

  static String spaces(int count) => ' ' * count;

  static String bracket(String text, {AnsiColor? textColor, String? emoji}) {
    final coloredText = textColor != null ? textColor(text) : text;
    final prefix = emoji != null ? '$emoji ' : '';
    return '${LogColors.noColor('[')} $prefix$coloredText ${LogColors.noColor(']')}';
  }

  static String levelName(Level level, AnsiColor color, String name) {
    return bracket(name, textColor: color);
  }

  static String formatUrl(String method, String url) {
    return '${bracket(method.toUpperCase(), textColor: LogColors.methodColor)} '
        '${LogColors.urlColor(url)}';
  }

  static String keyValue(String key, dynamic value, {AnsiColor? keyColor}) {
    final coloredKey = keyColor != null ? keyColor(key) : key;
    return '$coloredKey: ${LogColors.noColor(value.toString())}';
  }

  static String separator([int length = 80]) => '─' * length;

  static String header(String text, {String? emoji}) {
    return bracket(text, textColor: LogColors.infoColor, emoji: emoji);
  }
}
