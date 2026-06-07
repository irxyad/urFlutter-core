import 'package:freezed_annotation/freezed_annotation.dart';

import '../extensions/error_extension.dart';

part 'async_state.freezed.dart';

@freezed
abstract class AsyncState<T> with _$AsyncState<T> {
  const factory AsyncState.idle() = _Idle;
  const factory AsyncState.loading() = _Loading;
  const factory AsyncState.success(T data) = _Success;
  const factory AsyncState.failure(String error) = _Failure;

  static AsyncState<void> get done => const AsyncState.success(null);
}

extension AsyncStateX<T> on AsyncState<T> {
  bool get isLoading => this is _Loading<T>;
  bool get isSuccess => this is _Success<T>;
  bool get isFailure => this is _Failure<T>;
  bool get isIdle => this is _Idle<T>;

  T? get data => switch (this) {
    _Success<T>(:final data) => data,
    _ => null,
  };

  String? get error => switch (this) {
    _Failure<T>(:final error) => error,
    _ => null,
  };
}

extension AsyncStateBoolX on AsyncState<bool> {
  bool get orFalse => data ?? false;
}

extension AsyncValueX<T> on T {
  AsyncState<T> get toAsync => AsyncState.success(this);
}

extension AsyncErrorX on Object {
  AsyncState<T> toAsyncError<T>() => AsyncState.failure(message);
}
