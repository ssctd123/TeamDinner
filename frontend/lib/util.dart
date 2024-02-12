import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'Types/token.dart';
import 'api/users_repository.dart';
// Using token to make login functionality work
class Util {
  static Future<bool> login(String email, String password) async {
    try {
      var result = await UsersRepository.login(email, password);
      const storage = FlutterSecureStorage();
      storage.write(key: "token", value: result.token);
      storage.write(key: "wasPasswordReset", value: result.wasPasswordReset == true ? "true" : "false" );
      return true;
    } on Exception {
      return false;
    }
  }

  static Future<Token?> getAccessToken() async {
    const storage = FlutterSecureStorage();
    if (await storage.containsKey(key: "token")) {
      var token = await storage.read(key: "token") as String;
      var wasPasswordReset = await storage.read(key: "wasPasswordReset") as bool;
      return Token(token: token, wasPasswordReset: wasPasswordReset);
    }
    return null;
  }

  static void logout() {
    const storage = FlutterSecureStorage();
    storage.delete(key: "token");
  }
}
