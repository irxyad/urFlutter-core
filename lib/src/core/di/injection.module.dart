// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i687;

import 'package:dio/dio.dart' as _i361;
import 'package:injectable/injectable.dart' as _i526;
import 'package:shared_preferences/shared_preferences.dart' as _i460;
import 'package:urflutter_core/src/core/api/api.dart' as _i1051;
import 'package:urflutter_core/src/core/di/app_module.dart' as _i214;
import 'package:urflutter_core/src/core/local/preferences_client.dart' as _i537;

class UrflutterCorePackageModule extends _i526.MicroPackageModule {
// initializes the registration of main-scope dependencies inside of GetIt
  @override
  _i687.FutureOr<void> init(_i526.GetItHelper gh) async {
    final appModule = _$AppModule();
    await gh.lazySingletonAsync<_i460.SharedPreferences>(
      () => appModule.sharedPreferences,
      preResolve: true,
    );
    gh.lazySingleton<_i1051.ApiConfig>(() => appModule.apiConfig);
    gh.lazySingleton<_i361.Dio>(() => appModule.dio(gh<_i1051.ApiConfig>()));
    gh.lazySingleton<_i537.PreferencesClient>(
        () => _i537.PreferencesClient(gh<_i460.SharedPreferences>()));
  }
}

class _$AppModule extends _i214.AppModule {}
