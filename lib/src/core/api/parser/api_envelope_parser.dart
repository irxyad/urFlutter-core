abstract class ApiEnvelopeParser {
  const ApiEnvelopeParser();

  dynamic extractData(Map<String, dynamic> body);

  bool isSuccess(Map<String, dynamic> body) => true;

  String? extractErrorMessage(Map<String, dynamic> body) => null;
}
