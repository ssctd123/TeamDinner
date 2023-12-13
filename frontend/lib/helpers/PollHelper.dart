import 'package:shared_preferences/shared_preferences.dart';

class PollHelper {

  static String tlCustomPollKey = "customPoll";

  static Future<String> getCustomPollId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String result = prefs.getString(tlCustomPollKey) ?? "";
    return result;
  }

  static Future<void> saveCustomPollId(String pollId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(tlCustomPollKey, pollId);
  }
}