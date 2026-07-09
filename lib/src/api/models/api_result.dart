import 'failure.dart';

sealed class ApiResult<T> {
  const ApiResult();

  bool get isSuccess => this is ApiSuccess<T>;
  bool get isFailure => this is ApiFailure<T>;

  /// Ambil data langsung, null kalau failure
  T? get dataOrNull => switch (this) {
    ApiSuccess(:final data) => data,
    ApiFailure() => null,
  };

  /// Ambil failure langsung, null kalau success
  Failure? get failureOrNull => switch (this) {
    ApiSuccess() => null,
    ApiFailure(:final failure) => failure,
  };

  R when<R>({
    required R Function(T data) onSuccess,
    required R Function(Failure failure) onFailure,
  }) => switch (this) {
    ApiSuccess(:final data) => onSuccess(data),
    ApiFailure(:final failure) => onFailure(failure),
  };

  /// Map data kalau success, lewati kalau failure
  ApiResult<R> map<R>(R Function(T data) transform) => switch (this) {
    ApiSuccess(:final data) => ApiSuccess(transform(data)),
    ApiFailure(:final failure) => ApiFailure(failure),
  };
}

final class ApiSuccess<T> extends ApiResult<T> {
  final T data;
  const ApiSuccess(this.data);
}

final class ApiFailure<T> extends ApiResult<T> {
  final Failure failure;
  const ApiFailure(this.failure);
}
