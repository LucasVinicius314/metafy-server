import 'package:shared_preferences/shared_preferences.dart';

class Prefs {
  static Future<SharedPreferences> get prefs => SharedPreferences.getInstance();

  static Future<String?> getAuthorization() async {
    return (await prefs).getString('authorization');
  }

  static Future<void> setAuthorization(String authorization) async {
    (await prefs).setString('authorization', authorization);
  }

  static Future<void> unsetAuthorization() async {
    (await prefs).remove('authorization');
  }
}
