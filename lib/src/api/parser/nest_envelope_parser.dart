import 'api_envelope_parser.dart';

class NestEnvelopeParser extends ApiEnvelopeParser {
  const NestEnvelopeParser();

  @override
  dynamic extractData(Map<String, dynamic> body) => body['data'];

  @override
  bool isSuccess(Map<String, dynamic> body) => body['success'] == true;

  @override
  String? extractErrorMessage(Map<String, dynamic> body) =>
      body['message']?.toString();
}
