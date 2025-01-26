import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/friend_request.dart';
import '../models/user_model.dart';

class FriendService {
  static const String baseUrl = 'http://localhost:5000/api';

  static Future<void> sendFriendRequest(String friendId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/friends/request'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'friendId': friendId}),
    );

    if (response.statusCode != 201) {
      throw Exception('Error al enviar solicitud');
    }
  }

  static Future<List<FriendRequest>> getPendingRequests() async {
    final response = await http.get(
      Uri.parse('$baseUrl/friends/requests/pending'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => FriendRequest.fromJson(json)).toList();
    } else {
      throw Exception('Error al obtener solicitudes pendientes');
    }
  }

  static Future<List<User>> getFriendsList() async {
    final response = await http.get(
      Uri.parse('$baseUrl/friends/list'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => User.fromJson(json)).toList();
    } else {
      throw Exception('Error al obtener lista de amigos');
    }
  }

  static Future<void> respondToRequest(String requestId, bool accept) async {
    final response = await http.put(
      Uri.parse('$baseUrl/friends/request/$requestId'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'accept': accept}),
    );

    if (response.statusCode != 200) {
      throw Exception('Error al responder a la solicitud');
    }
  }
}