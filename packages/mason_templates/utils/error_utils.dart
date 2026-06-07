extension ErrorUtils on Object {
  String get message => toString()
      .replaceAll('Exception: ', '')
      .replaceAll('Generation Aborted: ', '');
}
