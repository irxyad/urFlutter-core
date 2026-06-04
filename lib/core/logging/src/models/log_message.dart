class LogMessage {
  final dynamic message;
  final String loggerName;
  final Map<String, dynamic>? metadata;

  const LogMessage(
    this.message,
    this.loggerName, {
    this.metadata,
  });

  @override
  String toString() => message.toString();
}