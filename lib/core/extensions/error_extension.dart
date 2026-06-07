extension ExceptionX on Exception {
  String get message => toString().replaceAll('Exception: ', '');
}

extension DynamicErrorX on Object {
  String get message {
    if (this is Exception) return toString().replaceAll('Exception: ', '');

    return toString();
  }
}
