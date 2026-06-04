import 'package:dio/dio.dart';

import '../models/api_result.dart';
import '../models/failure.dart';

class ErrorHandler {
  ErrorHandler._();

  static ApiFailure<T> handle<T>(Object error) {
    if (error is DioException) {
      return ApiFailure(_fromDioException(error));
    }

    // Error di luar Dio
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
        message: error.message ?? 'Terjadi kesalahan',
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
        message: serverMessage ?? 'Akses ditolak',
        statusCode: 403,
        originalError: error,
      ),
      404 => ServerFailure(
        message: serverMessage ?? 'Data tidak ditemukan',
        statusCode: 404,
        originalError: error,
      ),
      422 => ServerFailure(
        message: serverMessage ?? 'Data yang dikirim tidak valid',
        statusCode: 422,
        originalError: error,
      ),
      500 || 502 || 503 => ServerFailure(
        message: serverMessage ?? 'Server sedang bermasalah, coba lagi nanti',
        statusCode: statusCode,
        originalError: error,
      ),
      _ => ServerFailure(
        message: serverMessage ?? 'Terjadi kesalahan ($statusCode)',
        statusCode: statusCode,
        originalError: error,
      ),
    };
  }

  static String? _extractMessage(dynamic data) {
    if (data is Map<String, dynamic>) {
      return data['message'] as String? ??
          data['error'] as String? ??
          data['msg'] as String?;
    }
    return null;
  }
}
