import 'package:logger/logger.dart';

import '../printers/simple_log_printer.dart';

class LogConfig {
  final SimpleLogPrinter printer;
  final LogOutput? output;
  final LogFilter? filter;
  final Level? level;

  const LogConfig({
    required this.printer,
    this.output,
    this.filter,
    this.level,
  });

  LogConfig copyWith({
    SimpleLogPrinter? printer,
    LogOutput? output,
    LogFilter? filter,
    Level? level,
  }) {
    return LogConfig(
      printer: printer ?? this.printer,
      output: output ?? this.output,
      filter: filter ?? this.filter,
      level: level ?? this.level,
    );
  }
}
