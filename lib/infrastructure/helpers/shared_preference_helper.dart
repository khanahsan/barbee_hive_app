import 'package:shared_preferences/shared_preferences.dart';

import '../../data/api/token_storage.dart';
import '../../data/model/login_response.dart';
import '../constants/shared_pref_keys.dart';

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

  static saveInfo(
    LoginResponse response,
    bool isRememberMe,
    String email,
    String password,
  ) async {
    await Future.wait([
      TokenStorage.saveToken(response.token),
      SharedPreferenceHelper.saveInt(
        SharedPrefKeys.userRole,
        response.user.role,
      ),
      SharedPreferenceHelper.saveString(
        SharedPrefKeys.authToken,
        response.token,
      ),

      SharedPreferenceHelper.saveInt(SharedPrefKeys.userId, response.user.id),
      SharedPreferenceHelper.saveString(
        SharedPrefKeys.userProfileImage,
        response.user.profileImage ?? '',
      ),
      SharedPreferenceHelper.saveString(
        SharedPrefKeys.userName,
        response.user.role == 3
            ? response.user.employee?.name ?? ""
            : response.user.employer?.businessName ?? "",
      ),
      SharedPreferenceHelper.saveString(
        SharedPrefKeys.userEmail,
        response.user.email,
      ),
    ]);

    print(
      "GET TOKEN IN SAVE INFO : ${SharedPreferenceHelper.getString(
          SharedPrefKeys.authToken)}",
    );

    if (isRememberMe) {
      await Future.wait([
        SharedPreferenceHelper.saveString(SharedPrefKeys.savedEmail, email),
        SharedPreferenceHelper.saveString(
          SharedPrefKeys.savedPassword,
          password,
        ),
        SharedPreferenceHelper.remove(SharedPrefKeys.isRememberMe),
        SharedPreferenceHelper.remove(SharedPrefKeys.rememberMe),
      ]);
    } else {
      await Future.wait([
        SharedPreferenceHelper.remove(SharedPrefKeys.savedEmail),
        SharedPreferenceHelper.remove(SharedPrefKeys.savedPassword),
        SharedPreferenceHelper.remove(SharedPrefKeys.isRememberMe),
        SharedPreferenceHelper.remove(SharedPrefKeys.rememberMe),
      ]);
    }
  }
}
