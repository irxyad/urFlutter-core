import 'package:dio/dio.dart';

import '../models/api_result.dart';
import '../models/failure.dart';

class ErrorHandler {
  ErrorHandler._();

  static ApiFailure<T> handle<T>(Object error) {
    if (error is DioException) {
      return ApiFailure(_fromDioException(error));
    }

    return ApiFailure(
      UnknownFailure(message: error.toString(), originalError: error),
    );
  }

  static Failure _fromDioException(DioException error) {
    return switch (error.type) {
      // Koneksi bermasalah
      DioExceptionType.connectionError || DioExceptionType.connectionTimeout =>
        NetworkFailure(originalError: error),

      // Timeout tunggu response
      DioExceptionType.receiveTimeout ||
      DioExceptionType.sendTimeout => TimeoutFailure(originalError: error),

      // Server balas dengan status code error
      DioExceptionType.badResponse => _fromResponse(error),

      // Error lainnya
      _ => UnknownFailure(
        message: error.message ?? 'An error occurred',
        originalError: error,
      ),
    };
  }

  static Failure _fromResponse(DioException error) {
    final statusCode = error.response?.statusCode;
    final data = error.response?.data;

    // Coba ambil pesan error dari response body server
    final serverMessage = _extractMessage(data);

    return switch (statusCode) {
      401 => UnauthorizedFailure(originalError: error),
      403 => ServerFailure(
        message: serverMessage ?? 'Access forbidden',
        statusCode: 403,
        originalError: error,
      ),
      404 => ServerFailure(
        message: serverMessage ?? 'Resource not found',
        statusCode: 404,
        originalError: error,
      ),
      422 => ServerFailure(
        message: serverMessage ?? 'Invalid request',
        statusCode: 422,
        originalError: error,
      ),
      500 || 502 || 503 => ServerFailure(
        message: serverMessage ?? 'Server error',
        statusCode: statusCode,
        originalError: error,
      ),
      _ => ServerFailure(
        message: serverMessage ?? 'Unknown error ($statusCode)',
        statusCode: statusCode,
        originalError: error,
      ),
    };
  }

  static String? _extractMessage(dynamic data) {
    if (data is String) {
      return data;
    }

    if (data is! Map) {
      return null;
    }

    final message = data['message'];

    if (message is String) {
      return message;
    }

    final error = data['error'];

    if (error is String) {
      return error;
    }

    if (error is Map) {
      final nestedMessage = error['message'];

      if (nestedMessage is String) {
        return nestedMessage;
      }
    }

    final msg = data['msg'];

    if (msg is String) {
      return msg;
    }

    return null;
  }
}
