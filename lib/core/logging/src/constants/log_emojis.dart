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

  static const String get = '📥';
  static const String post = '📤';
  static const String put = '📝';
  static const String delete = '🗑️';
  static const String patch = '🔧';

  static const String request = '🚀';
  static const String response = '🗨️';
  static const String error = '⛔';
  static const String success = '✅';
  static const String loading = '⏳';

  static String getMethodEmoji(String method) {
    switch (method.toUpperCase()) {
      case 'GET':
        return get;
      case 'POST':
        return post;
      case 'PUT':
        return put;
      case 'DELETE':
        return delete;
      case 'PATCH':
        return patch;
      default:
        return '📡';
    }
  }
}
