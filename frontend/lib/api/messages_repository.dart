import 'dart:convert';

import 'package:http/http.dart' as http;

import '../Types/message.dart';
import '../util.dart';
import 'base_repository.dart';
// Repository for users, stores descriptions and behaviors of user object
class LocationsRepository extends BaseRepository {
  static final Map<String, String> headers = <String, String>{
    'Content-Type': 'application/json; charset=UTF-8',
  };
  static const String repositoryName = "messages";
  // Handles login function for the user
  static Future<Message> create(String body) async {
    final response = await http.post(
      Uri.parse("${BaseRepository.baseUrl}/$repositoryName/create"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        "Authorization": "Bearer ${(await Util.getAccessToken())!.token}"
      },
      body: jsonEncode(<String, dynamic>{
        'body': body
      }),
    );
    // Error handling, failed to login
    if (response.statusCode == 201) {
      return Message.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create a Message for the team.');
    }
  }
}
