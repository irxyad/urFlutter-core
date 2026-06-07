import '../api/api.dart';

abstract class UseCase<T, Params> {
  const UseCase();
  Future<ApiResult<T>> call(Params params);
}

abstract class NoParamsUseCase<T> {
  const NoParamsUseCase();
  Future<ApiResult<T>> call();
}

abstract class LocalUseCase<T, Params> {
  const LocalUseCase();
  T call(Params params);
}

abstract class LocalUseCaseAsync<T, Params> {
  const LocalUseCaseAsync();
  Future<T> call(Params params);
}

abstract class NoParamsLocalUseCase<T> {
  const NoParamsLocalUseCase();
  T call();
}
