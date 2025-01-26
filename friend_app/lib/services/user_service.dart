import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';

class UserService {
  static const String baseUrl = 'http://localhost:5000/api';

  static Future<User> registerUser(Map<String, dynamic> userData) async {
    final response = await http.post(
      Uri.parse('$baseUrl/users/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(userData),
    );

    if (response.statusCode == 201) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Error al registrar usuario');
    }
  }

  static Future<User> updateProfile(String userId, Map<String, dynamic> profileData) async {
    final response = await http.put(
      Uri.parse('$baseUrl/users/$userId'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(profileData),
    );

    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Error al actualizar perfil');
    }
  }

  static Future<List<User>> searchUsers(Map<String, dynamic> filters) async {
    final queryString = Uri(queryParameters: filters).query;
    final response = await http.get(Uri.parse('$baseUrl/users/search?$queryString'));

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => User.fromJson(json)).toList();
    } else {
      throw Exception('Error al buscar usuarios');
    }
  }
}