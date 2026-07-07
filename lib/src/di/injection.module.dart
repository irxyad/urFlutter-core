// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i687;

import 'package:dio/dio.dart' as _i361;
import 'package:injectable/injectable.dart' as _i526;
import 'package:shared_preferences/shared_preferences.dart' as _i460;
import 'package:urflutter_core/src/api/api.dart' as _i637;
import 'package:urflutter_core/src/di/app_module.dart' as _i996;
import 'package:urflutter_core/src/local/preferences_client.dart' as _i333;

class UrflutterCorePackageModule extends _i526.MicroPackageModule {
// initializes the registration of main-scope dependencies inside of GetIt
  @override
  _i687.FutureOr<void> init(_i526.GetItHelper gh) async {
    final appModule = _$AppModule();
    await gh.lazySingletonAsync<_i460.SharedPreferences>(
      () => appModule.sharedPreferences,
      preResolve: true,
    );
    gh.lazySingleton<_i637.ApiConfig>(() => appModule.apiConfig);
    gh.lazySingleton<_i333.PreferencesClient>(
        () => _i333.PreferencesClient(gh<_i460.SharedPreferences>()));
    gh.lazySingleton<_i361.Dio>(() => appModule.dio(gh<_i637.ApiConfig>()));
  }
}

class _$AppModule extends _i996.AppModule {}
