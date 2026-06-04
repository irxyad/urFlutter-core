sealed class Failure {
  final String message;
  final int? statusCode;
  final Object? originalError;

  const Failure({required this.message, this.statusCode, this.originalError});

  @override
  String toString() =>
      '$runtimeType(message: $message, statusCode: $statusCode)';
}

final class NetworkFailure extends Failure {
  const NetworkFailure({
    super.message = 'Tidak ada koneksi internet',
    super.statusCode,
    super.originalError,
  });
}

final class ServerFailure extends Failure {
  const ServerFailure({
    required super.message,
    required super.statusCode,
    super.originalError,
  });
}

final class TimeoutFailure extends Failure {
  const TimeoutFailure({
    super.message = 'Koneksi timeout, coba lagi',
    super.statusCode,
    super.originalError,
  });
}

final class ParseFailure extends Failure {
  const ParseFailure({
    super.message = 'Gagal memproses data dari server',
    super.statusCode,
    super.originalError,
  });
}

final class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure({
    super.message = 'Sesi habis, silakan login ulang',
    super.statusCode = 401,
    super.originalError,
  });
}

final class UnknownFailure extends Failure {
  const UnknownFailure({
    super.message = 'Terjadi kesalahan yang tidak diketahui',
    super.statusCode,
    super.originalError,
  });
}
