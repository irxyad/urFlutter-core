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
}
