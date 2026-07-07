class LogMessage {
  final dynamic message;
  final String? loggerName;
  final Map<String, dynamic>? metadata;
  final bool showIndicator;

  const LogMessage(
    this.message, {
    required this.showIndicator,
    this.loggerName,
    this.metadata,
  });

  @override
  String toString() => message.toString();
}
