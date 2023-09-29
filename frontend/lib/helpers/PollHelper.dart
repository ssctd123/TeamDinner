import 'package:shared_preferences/shared_preferences.dart';

class PollHelper {

  static String tlPollStageKey = "tlPollStage";

  static Future<bool> hasPollBeenSplit(String pollId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    bool result = prefs.getBool(pollId) ?? false;
    return result;
  }

  static Future<void> saveHasPollBeenSplit(String pollId, bool hasBeenSplit) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(pollId, hasBeenSplit);
  }

  static Future<int> getTLPollStage() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    int result = prefs.getInt(tlPollStageKey) ?? 0;
    return result;
  }

  static Future<void> saveTLPollStage(int value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (value >= 2) {
      value = 0;
    }
    prefs.setInt(tlPollStageKey, value);
  }
}