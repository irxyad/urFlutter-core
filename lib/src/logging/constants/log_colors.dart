import 'package:logger/logger.dart';

class LogColors {
  LogColors._();

  static final Map<Level, AnsiColor> levelColors = {
    Level.trace: AnsiColor.fg(AnsiColor.grey(0.5)),
    Level.debug: const AnsiColor.none(),
    Level.info: const AnsiColor.fg(2),
    Level.warning: const AnsiColor.fg(208),
    Level.error: const AnsiColor.fg(196),
    Level.fatal: const AnsiColor.fg(199),
  };

  static const AnsiColor noColor = AnsiColor.fg(244);
  static const AnsiColor nameColor = AnsiColor.fg(45);
  static const AnsiColor infoColor = AnsiColor.fg(2);
  static const AnsiColor methodColor = AnsiColor.fg(199);
  static const AnsiColor urlColor = AnsiColor.fg(45);
  static const AnsiColor errorColor = AnsiColor.fg(196);

  static const AnsiColor timestampColor = AnsiColor.fg(244);

  static AnsiColor getStatusCodeColor(int statusCode) {
    if (statusCode >= 200 && statusCode < 300) {
      return const AnsiColor.fg(2);
    } else if (statusCode >= 300 && statusCode < 400) {
      return const AnsiColor.fg(208);
    } else if (statusCode >= 400 && statusCode < 500) {
      return const AnsiColor.fg(196);
    } else if (statusCode >= 500) {
      return const AnsiColor.fg(199);
    }
    return noColor;
  }

  static AnsiColor getMethodColor(String method) {
    switch (method.toUpperCase()) {
      case 'GET':
        return const AnsiColor.fg(45);
      case 'POST':
        return const AnsiColor.fg(2);
      case 'PUT':
        return const AnsiColor.fg(208);
      case 'PATCH':
        return const AnsiColor.fg(220);
      case 'DELETE':
        return const AnsiColor.fg(196);
      default:
        return noColor;
    }
  }
}
