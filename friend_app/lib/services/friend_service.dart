import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/friend_request.dart';
import '../models/user_model.dart';
class FriendService {
  static const String baseUrl = 'http://127.0.0.1:5000/api';

  static Future<void> sendFriendRequest(String userId, String token) async {
    try {
      print('Debug - userId: $userId, token: $token');
      
      final uri = Uri.parse('$baseUrl/friends/$userId');
      print('Debug - Request URL: $uri');

      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('Debug - Status: ${response.statusCode}');
      print('Debug - Body: ${response.body}');

      if (response.statusCode != 201) { // Changed from 200 to 201
        final error = jsonDecode(response.body);
        throw Exception(error['msg'] ?? 'Error desconocido');
      }
    } catch (e) {
      print('Debug - Error: $e');
      throw Exception('Error al enviar solicitud: $e');
    }
  }

  static Future<List<FriendRequest>> getPendingRequests(String token) async {
  try {
    final response = await http.get(
      Uri.parse('$baseUrl/friends/requests/pending'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    print('Debug - Pending Requests Status: ${response.statusCode}');
    print('Debug - Raw Response Body: ${response.body}');

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      print('Debug - Parsed JSON: $data');
      
      return data.map((json) {
        print('Debug - Processing request: $json');
        return FriendRequest.fromJson(json);
      }).toList();
    } else {
      throw Exception(jsonDecode(response.body)['msg']);
    }
  } catch (e) {
    print('Debug - Parse Error: $e');
    throw Exception('Error al obtener solicitudes: $e');
  }
}

  static Future<void> respondToRequest(String requestId, bool accept, String token) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/friends/request/$requestId/${accept ? 'accept' : 'reject'}'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('Debug - Response Status: ${response.statusCode}');
      print('Debug - Response Body: ${response.body}');

      if (response.statusCode != 200) {
        throw Exception(jsonDecode(response.body)['msg']);
      }
    } catch (e) {
      print('Debug - Error: $e');
      throw Exception('Error al responder solicitud: $e');
    }
  }
  static Future<List<User>> getFriendsList(String token) async {
  try {
    print('Debug - Getting friends list');
    print('Debug - Token: $token');

    final response = await http.get(
      Uri.parse('$baseUrl/friends/list'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    print('Debug - Status: ${response.statusCode}');
    print('Debug - Body: ${response.body}');

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) {
        print('Debug - Processing user: $json');
        return User.fromJson(json);
      }).toList();
    } else {
      final error = jsonDecode(response.body);
      throw Exception(error['msg'] ?? 'Error al obtener lista de amigos');
    }
  } catch (e) {
    print('Debug - Error: $e');
    throw Exception('Error al obtener amigos: $e');
  }
}
}