import 'package:shared_preferences/shared_preferences.dart';

class LocalSettings {
  late SharedPreferences _preferences;

  Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  Future<void> setUserLoggedIn(bool value) async {
    await _preferences.setBool('is_logged_in', value);
  }

  bool isUserLoggedIn() {
    return _preferences.getBool('is_logged_in') ?? false;
  }

  Future<void> clearUserSession() async {
    await _preferences.remove('is_logged_in');
  }
}
