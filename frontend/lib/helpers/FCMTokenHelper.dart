import 'package:shared_preferences/shared_preferences.dart';

class FCMTokenHelper {

  static String fcmTokenKey = "fcmToken";

  static Future<void> saveFCMToken(String token) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(fcmTokenKey, token);
  }

  static Future<String> getFCMToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String result = prefs.getString(fcmTokenKey) ?? "";
    return result;
  }
}