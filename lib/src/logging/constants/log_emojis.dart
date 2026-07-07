import 'package:logger/logger.dart';

class LogEmojis {
  LogEmojis._();

  static final Map<Level, String> levelEmojis = {
    Level.trace: '🔍',
    Level.debug: '🪲',
    Level.info: '📣',
    Level.warning: '☢️',
    Level.error: '⛔',
    Level.fatal: '💀',
  };

  static const String request = '🚀';
  static const String response = '🗨️';
  static const String error = '⛔';
  static const String success = '✅';
  static const String loading = '⏳';
}
