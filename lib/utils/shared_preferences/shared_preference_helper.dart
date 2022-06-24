import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:tr_tree/utils/shared_preferences/preferences.dart';

class SharedPreferenceHelper {
  // shared pref instance
  static late SharedPreferences _sharedPreference;

  // initialization
  static Future init() async =>
      _sharedPreference = await SharedPreferences.getInstance();

  // Login:---------------------------------------------------------------------
  static Future<bool> get isLoggedIn async {
    return _sharedPreference.getBool(Preferences.isLoggedIn) ?? false;
  }

  static Future<bool> saveIsLoggedIn(bool value) async {
    return _sharedPreference.setBool(Preferences.isLoggedIn, value);
  }

  static Future<void> saveUserType(String value) async {
    await _sharedPreference.setString(Preferences.userType, value);
  }

  static String get getUserType {
    return (_sharedPreference.getString(Preferences.userType)) ?? 'user';
  }

  static bool checkKey(String key) => _sharedPreference.containsKey(key);
  static Future<bool> removeKey(String key) async =>
      await _sharedPreference.remove(key);
  static Future reset() async {
    await init();
    await _sharedPreference.clear();
  }
}
