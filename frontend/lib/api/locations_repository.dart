import 'dart:convert';

import 'package:http/http.dart' as http;

import '../Types/location.dart';
import 'base_repository.dart';
// Repository for users, stores descriptions and behaviors of user object
class LocationsRepository extends BaseRepository {
  static final Map<String, String> headers = <String, String>{
    'Content-Type': 'application/json; charset=UTF-8',
  };
  static const String repositoryName = "locations";
  // Handles login function for the user
  static Future<Location> create(String name, String time) async {
    final response = await http.post(
      Uri.parse("${BaseRepository.baseUrl}/$repositoryName/create"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{'name': name, 'time': time}),
    );
    // Error handling, failed to login
    if (response.statusCode == 201) {
      return Location.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create a Location for the team.');
    }
  }
}
