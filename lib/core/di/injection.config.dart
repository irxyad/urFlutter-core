// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:shared_preferences/shared_preferences.dart' as _i460;
import 'package:urflutter_core/core/di/app_module.dart' as _i869;
import 'package:urflutter_core/core/local/preferences_client.dart' as _i378;

// initializes the registration of main-scope dependencies inside of GetIt
Future<_i174.GetIt> initDependencies(
  _i174.GetIt getIt, {
  String? environment,
  _i526.EnvironmentFilter? environmentFilter,
}) async {
  final gh = _i526.GetItHelper(getIt, environment, environmentFilter);
  final appModule = _$AppModule();
  await gh.lazySingletonAsync<_i460.SharedPreferences>(
    () => appModule.sharedPreferences,
    preResolve: true,
  );
  gh.lazySingleton<_i378.PreferencesClient>(
    () => _i378.PreferencesClient(gh<_i460.SharedPreferences>()),
  );
  return getIt;
}

class _$AppModule extends _i869.AppModule {}
