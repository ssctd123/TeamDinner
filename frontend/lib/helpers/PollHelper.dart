import 'package:shared_preferences/shared_preferences.dart';

class PollHelper {

  static Future<bool> hasPollBeenSplit(String pollId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    bool result = prefs.getBool(pollId) ?? false;
    return result;
  }

  static Future<void> saveHasPollBeenSplit(String pollId, bool hasBeenSplit) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(pollId, hasBeenSplit);
  }
}