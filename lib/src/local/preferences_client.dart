import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

@lazySingleton
class PreferencesClient {
  final SharedPreferences _prefs;

  PreferencesClient(this._prefs);

  // String
  String? getString(String key) => _prefs.getString(key);

  Future<bool> setString(String key, String value) =>
      _prefs.setString(key, value);

  // Int
  int? getInt(String key) => _prefs.getInt(key);

  Future<bool> setInt(String key, int value) => _prefs.setInt(key, value);

  // Bool
  bool? getBool(String key) => _prefs.getBool(key);

  Future<bool> setBool(String key, bool value) => _prefs.setBool(key, value);

  // Double
  double? getDouble(String key) => _prefs.getDouble(key);

  Future<bool> setDouble(String key, double value) =>
      _prefs.setDouble(key, value);

  // List
  List<String>? getStringList(String key) => _prefs.getStringList(key);

  Future<bool> setStringList(String key, List<String> value) =>
      _prefs.setStringList(key, value);

  // Utils
  Future<bool> remove(String key) => _prefs.remove(key);

  Future<bool> clear() async => await _prefs.clear();

  bool containsKey(String key) => _prefs.containsKey(key);

  // Metode untuk menyimpan bahasa
  Future<bool> saveLanguage(Locale locale) async {
    final languageCode = locale.languageCode;
    final countryCode = locale.countryCode;

    return _prefs.setString('language_code', '$languageCode/$countryCode');
  }

  // Metode untuk memuat bahasa
  Locale? loadLanguage() {
    final key = _prefs.getString('language_code');

    if (key == null) return null;
    final splitted = key.split('/');

    if (splitted.length != 2) {
      deleteLanguage();
      return null;
    }

    final languageCode = splitted[0];
    final countryCode = splitted[1];

    return Locale(languageCode, countryCode);
  }

  // Metode untuk menghapus bahasa
  Future<bool> deleteLanguage() async {
    return _prefs.remove('language_code');
  }
}
