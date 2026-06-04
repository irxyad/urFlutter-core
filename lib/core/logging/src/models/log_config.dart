import 'package:logger/logger.dart';

class LogConfig {
  final String defaultLoggerName;
  final Level level;
  final LogPrinter printer;
  final LogOutput output;
  final LogFilter? filter;
  final bool showTime;
  final bool showEmoji;
  final bool showColors;

  const LogConfig({
    this.defaultLoggerName = 'AppLogger',
    this.level = Level.all,
    required this.printer,
    required this.output,
    this.filter,
    this.showTime = true,
    this.showEmoji = true,
    this.showColors = true,
  });

  LogConfig copyWith({
    String? defaultLoggerName,
    Level? level,
    LogPrinter? printer,
    LogOutput? output,
    LogFilter? filter,
    bool? showTime,
    bool? showEmoji,
    bool? showColors,
  }) {
    return LogConfig(
      defaultLoggerName: defaultLoggerName ?? this.defaultLoggerName,
      level: level ?? this.level,
      printer: printer ?? this.printer,
      output: output ?? this.output,
      filter: filter ?? this.filter,
      showTime: showTime ?? this.showTime,
      showEmoji: showEmoji ?? this.showEmoji,
      showColors: showColors ?? this.showColors,
    );
  }
}
