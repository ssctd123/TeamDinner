import 'dart:convert';

import 'package:http/http.dart' as http;

import '../Types/token.dart';

class AccountsRepository {
  static const String baseUrl = "https://team-dinner-jib-2341.vercel.app/";
  static final Map<String, String> headers = <String, String>{
    'Content-Type': 'application/json; charset=UTF-8',
  };
  static const String repositoryName = "accounts";

  static Future<Token> login(String email, password) async {
    final response = await http.post(
      Uri.parse("$baseUrl/$repositoryName/login"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{'email': email, 'password': password}),
    );
    if (response.statusCode == 200) {
      return Token.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to login.');
    }
  }
}
