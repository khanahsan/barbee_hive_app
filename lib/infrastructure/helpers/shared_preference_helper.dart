import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceHelper {
  static SharedPreferences? _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Save data
  static Future<void> saveString(String key, String value) async {
    await _prefs?.setString(key, value);
  }

  static Future<void> saveBool(String key, bool value) async {
    await _prefs?.setBool(key, value);
  }

  static Future<void> saveInt(String key, int value) async {
    await _prefs?.setInt(key, value);
  }

  static Future<void> saveDouble(String key, double value) async {
    await _prefs?.setDouble(key, value);
  }

  // Read data
  static String? getString(String key) => _prefs?.getString(key);
  static bool? getBool(String key) => _prefs?.getBool(key);
  static int? getInt(String key) => _prefs?.getInt(key);
  static double? getDouble(String key) => _prefs?.getDouble(key);

  // Remove specific key
  static Future<void> remove(String key) async {
    await _prefs?.remove(key);
  }

  // Clear all data
  static Future<void> clear() async {
    await _prefs?.clear();
  }
}
