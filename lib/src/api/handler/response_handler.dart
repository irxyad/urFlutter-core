import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../models/api_result.dart';
import '../models/failure.dart';
import '../parser/api_envelope_parser.dart';

class ResponseHandler {
  ResponseHandler._();

  static ApiEnvelopeParser? _parser;

  static void configure({required ApiEnvelopeParser parser}) {
    _parser = parser;
  }

  static ApiResult<T> process<T>({
    required Response<dynamic> response,
    T Function(dynamic)? fromJson,

    /// Set `false` untuk endpoint yang tidak mengikuti envelope standar
    bool useEnvelope = true,
  }) {
    try {
      final statusCode = response.statusCode ?? 0;
      if (statusCode < 200 || statusCode >= 300) {
        return ApiFailure(
          ServerFailure(
            message: 'Status code invalid: $statusCode',
            statusCode: statusCode,
          ),
        );
      }

      final body = response.data;
      final activeParser = useEnvelope ? _parser : null;

      if (activeParser == null) {
        return fromJson != null
            ? ApiSuccess(fromJson(body))
            : ApiSuccess(body as T);
      }

      if (body is! Map<String, dynamic>) {
        return ApiFailure(
          ParseFailure(
            message: 'Expected JSON object, got: ${body.runtimeType}',
            originalError: body,
          ),
        );
      }

      if (!activeParser.isSuccess(body)) {
        return ApiFailure(
          ServerFailure(
            message:
                activeParser.extractErrorMessage(body) ??
                'Unknown server error',
            statusCode: statusCode,
          ),
        );
      }

      final data = activeParser.extractData(body);

      return fromJson != null
          ? ApiSuccess(fromJson(data))
          : ApiSuccess(data as T);
    } catch (e, str) {
      debugPrintStack(stackTrace: str);

      return ApiFailure(
        ParseFailure(
          message: 'Failed to parse response',
          originalError: e,
          stackTrace: str,
        ),
      );
    }
  }
}
