import 'package:dio/dio.dart';

import '../models/api_result.dart';
import '../models/failure.dart';

class ResponseHandler {
  ResponseHandler._();

  static ApiResult<T> process<T>({
    required Response<dynamic> response,
    T Function(Map<String, dynamic>)? fromJson,
  }) {
    try {
      final statusCode = response.statusCode ?? 0;
      if (statusCode < 200 || statusCode >= 300) {
        return ApiFailure(
          ServerFailure(
            message: 'Status code tidak valid: $statusCode',
            statusCode: statusCode,
          ),
        );
      }

      final data = response.data;

      if (fromJson == null) {
        return ApiSuccess(data as T);
      }

      if (data is Map<String, dynamic>) {
        return ApiSuccess(fromJson(data));
      }

      return ApiFailure(
        ParseFailure(
          message: 'Format response tidak sesuai: ${data.runtimeType}',
          originalError: data,
        ),
      );
    } catch (e) {
      return ApiFailure(
        ParseFailure(
          message: 'Gagal parse data: ${e.toString()}',
          originalError: e,
        ),
      );
    }
  }
}
