import 'dart:convert';

import 'package:http/http.dart' as http;

import '../Types/token.dart';
import '../Types/user.dart';
import '../Types/user_type.dart';
import '../util.dart';
import 'base_repository.dart';
// Repository for users, stores descriptions and behaviors of user object
class UsersRepository extends BaseRepository {
  static final Map<String, String> headers = <String, String>{
    'Content-Type': 'application/json; charset=UTF-8',
  };
  static const String repositoryName = "users";
  // Handles login function for the user
  static Future<Token> login(String email, String password) async {
    final response = await http.post(
      Uri.parse("${BaseRepository.baseUrl}/$repositoryName/login"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{'email': email, 'password': password}),
    );
    // Error handling, failed to login
    if (response.statusCode == 201) {
      return Token.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to login.');
    }
  }
  // Handles signup function, processes firstName, lastName, email, and password
  static Future<User> signup(
      String firstName, String lastName, String email, String password, UserType userType) async {
    final response = await http.post(
      Uri.parse("${BaseRepository.baseUrl}/$repositoryName/signup"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'password': password,
        'userType': userType.toString()
      }),
    );
    // Error handling failed to signup
    if (response.statusCode == 201) {
      return User.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to signup.');
    }
  }
  // Handles modify your own user info
  static Future<User> modify(Map<String, dynamic> values) async {
    final response = await http.post(
      Uri.parse("${BaseRepository.baseUrl}/$repositoryName/modify"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        "Authorization": "Bearer ${(await Util.getAccessToken())!.token}"
      },
      body: jsonEncode(values),
    );
    //Error handling failed to modify user info
    print(response.statusCode);
    if (response.statusCode == 201) {
      return User.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to modify.');
    }
  }
  // Handles finding a specific user
  static Future<User> get(String? id) async {
    final response = await http.get(
      Uri.parse("${BaseRepository.baseUrl}/$repositoryName${id != null ? "?id=$id" : ""}"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        "Authorization": "Bearer ${(await Util.getAccessToken())!.token}"
      },
    );
    // Error handling failed to find user
    if (response.statusCode == 200) {
      return User.fromJson(json.decode(response.body));
    } else {
      throw Exception('User not found.');
    }
  }
  // Handles requesting a password reset
  static Future<bool> sendResetPassword(String? email) async {
    final response = await http.get(
      Uri.parse("${BaseRepository.baseUrl}/$repositoryName/sendResetPassword${email != null ? "?email=$email" : ""}"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
    );
    //Error handling failed to send password reset
    print(response.statusCode);
    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Failed to send reset password.');
    }
  }
}
