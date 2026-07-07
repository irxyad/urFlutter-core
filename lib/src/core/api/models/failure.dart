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
    super.message =
        'No internet connection. Please check your network and try again.',
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
    super.message = 'The request timed out. Please try again.',
    super.statusCode,
    super.originalError,
  });
}

final class ParseFailure extends Failure {
  const ParseFailure({
    super.message = 'Failed to process the server response.',
    super.statusCode,
    super.originalError,
    this.stackTrace,
  });

  final StackTrace? stackTrace;
}

final class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure({
    super.message = 'Your session has expired. Please sign in again.',
    super.statusCode = 401,
    super.originalError,
  });
}

/// Error yang sengaja dilempar untuk ditampilkan ke user, contoh:
/// `throw Exception('Printer sedang digunakan untuk mencetak')`.
/// Berbeda dari [UnknownFailure] karena ini adalah expected state /
/// validasi bisnis, bukan error tak terduga.
final class BusinessFailure extends Failure {
  const BusinessFailure({
    required super.message,
    super.statusCode,
    super.originalError,
  });
}

final class UnknownFailure extends Failure {
  const UnknownFailure({
    super.message = 'Something went wrong. Please try again later.',
    super.statusCode,
    super.originalError,
  });
}
