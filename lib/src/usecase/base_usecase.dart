import 'package:urflutter_core/src/api/api.dart';

abstract class UseCase<T, Params> {
  const UseCase();

  Future<ApiResult<T>> call(Params params);
}

abstract class UseCaseNoParams<T> {
  const UseCaseNoParams();

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

abstract class LocalUseCaseNoParams<T> {
  const LocalUseCaseNoParams();

  T call();
}

abstract class LocalUseCaseNoParamsAsync<T> {
  const LocalUseCaseNoParamsAsync();

  Future<T> call();
}

abstract class UseCaseWithProgress<T, Params> {
  const UseCaseWithProgress();

  Future<ApiResult<T>> call(
    Params params, {
    void Function(int, int)? onReceiveProgress,
  });
}
