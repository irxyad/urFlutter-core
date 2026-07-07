import 'dart:async';
import 'dart:io';

import 'package:freezed_annotation/freezed_annotation.dart';

import '../api/models/failure.dart';

part 'async_state.freezed.dart';

@freezed
abstract class AsyncState<T> with _$AsyncState<T> {
  const factory AsyncState.idle() = _Idle;
  const factory AsyncState.loading() = _Loading;
  const factory AsyncState.success(T data) = _Success;
  const factory AsyncState.failure(Failure error) = _Failure;

  static AsyncState<void> get done => const AsyncState.success(null);
}

extension AsyncStateX<T> on AsyncState<T> {
  bool get isLoading => this is _Loading<T>;
  bool get isSuccess => this is _Success<T>;
  bool get isFailure => this is _Failure<T>;
  bool get isIdle => this is _Idle<T>;
  bool get hasData => isSuccess && data != null;

  T? get data => switch (this) {
    _Success<T>(:final data) => data,
    _ => null,
  };

  Failure? get error => switch (this) {
    _Failure<T>(:final error) => error,
    _ => null,
  };
}

extension AsyncStateBoolX on AsyncState<bool> {
  bool get orFalse => data ?? false;
}

extension AsyncValueX<T> on T {
  AsyncState<T> get asAsyncSuccess => AsyncState.success(this);
}

extension AsyncErrorX on Object {
  /// Mengubah error/exception apapun menjadi [AsyncState.failure] dengan
  /// [Failure] yang sesuai.
  ///
  /// Urutan switch penting: dari yang paling spesifik ke paling umum,
  /// karena beberapa exception bawaan Dart (SocketException,
  /// TimeoutException, FormatException) juga `implements Exception`.
  AsyncState<T> asAsyncFailure<T>([StackTrace? stackTrace]) {
    final error = this;

    final failure = switch (error) {
      Failure() => error,

      // Tidak ada koneksi internet
      SocketException() => NetworkFailure(originalError: error),

      // Request timeout (misal dari Future.timeout, atau http client)
      TimeoutException() => TimeoutFailure(originalError: error),

      // Gagal parsing response (json decode, type cast, dll)
      FormatException() => ParseFailure(
        originalError: error,
        stackTrace: stackTrace,
      ),
      TypeError() => ParseFailure(originalError: error, stackTrace: stackTrace),

      // Sertifikat/handshake TLS bermasalah, anggap sebagai network issue
      HandshakeException() => NetworkFailure(originalError: error),
      TlsException() => NetworkFailure(originalError: error),

      // Exception biasa, contoh: throw Exception('pesan custom')
      // Dianggap business/validation error yang message-nya sengaja
      // ditulis untuk ditampilkan ke user.
      Exception() => BusinessFailure(
        message: _extractExceptionMessage(error),
        originalError: error,
      ),

      // Fallback untuk Error atau object lain yang tidak dikenali
      _ => UnknownFailure(originalError: error),
    };

    return AsyncState.failure(failure);
  }
}

/// `Exception('pesan').toString()` menghasilkan `"Exception: pesan"`.
/// Strip prefix tersebut biar message yang ditampilkan bersih.
String _extractExceptionMessage(Exception exception) {
  final raw = exception.toString();
  return raw.startsWith('Exception: ') ? raw.substring(11) : raw;
}
