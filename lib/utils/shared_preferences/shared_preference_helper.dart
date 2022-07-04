import 'package:shared_preferences/shared_preferences.dart';
import 'package:tr_tree/models/user.dart';
import 'package:tr_tree/utils/shared_preferences/preferences.dart';

class SharedPreferenceHelper {
  // shared pref instance
  static late SharedPreferences _sharedPreference;

  // initialization
  static Future init() async =>
      _sharedPreference = await SharedPreferences.getInstance();

  // Login:---------------------------------------------------------------------
  static bool get isLoggedIn {
    return _sharedPreference.getBool(Preferences.isLoggedIn) ?? false;
  }

  static Future<bool> saveIsLoggedIn(bool value) async {
    return _sharedPreference.setBool(Preferences.isLoggedIn, value);
  }
  // User Type:---------------------------------------------------------------------

  static Future<void> saveUserType(String value) async {
    await _sharedPreference.setString(Preferences.userType, value);
  }

  static String get getUserType {
    return (_sharedPreference.getString(Preferences.userType)) ?? 'user';
  }

  // User:---------------------------------------------------------------------

  static Future<void> saveUser(Map value) async {
    final User user = User.fromMap(value as Map<String, dynamic>);
    await _sharedPreference.setString(Preferences.user, user.toJson());
  }

  static User? get getUser {
    final String? user = _sharedPreference.getString(Preferences.user);
    if (user == null) {
      return null;
    }
    return User.fromJson(user);
  }

  // Other:---------------------------------------------------------------------

  static bool checkKey(String key) => _sharedPreference.containsKey(key);
  static Future<bool> removeKey(String key) async =>
      await _sharedPreference.remove(key);
  static Future<void> reset() async {
    await init();
    await _sharedPreference.clear();
  }
}
