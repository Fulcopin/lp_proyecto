import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class UserService {
  static const String baseUrl = 'http://localhost:5000/api';
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
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



  static Future<Map<String, dynamic>> updateProfile(String userId, Map<String, dynamic> profileData) async {
    try {
      final url = '$baseUrl/users/profile/$userId';
      print('Request URL: $url');
      
      final response = await http.put(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'interests': profileData['interests'],
          'description': profileData['description'],
        }),
      );

      print('Response Status: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Error al actualizar perfil: ${response.statusCode}');
      }
    } catch (e) {
      print('Update Error: $e');
      rethrow;
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

  
  

  static Future<Map<String, dynamic>> getUserProfile(String userId) async {
    try {
      final DocumentSnapshot doc = await _firestore
          .collection('users')
          .doc(userId)
          .get();

      if (!doc.exists) {
        return {
          'description': '',
          'interests': [],
          'profileImage': null,
        };
      }

      return {
        'description': doc.get('description') ?? '',
        'interests': List<String>.from(doc.get('interests') ?? []),
        'profileImage': doc.get('profileImage'),
      };
    } catch (e) {
      throw Exception('Error fetching user profile: $e');
    }
  }

  static Future<void> updateFirestoreProfile(String userId, Map<String, dynamic> data) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .set(data, SetOptions(merge: true));
    } catch (e) {
      throw Exception('Error updating profile: $e');
    }
  }
}