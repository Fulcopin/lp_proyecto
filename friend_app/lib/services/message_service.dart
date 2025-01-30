import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/message_model.dart';

class MessageService {
  static const String baseUrl = 'http://127.0.0.1:5000/api/messages';


  static Future<List<Message>> getReceivedMessages(String token) async {
    try {
      print('Calling API: $baseUrl/received');
      
      final response = await http.get(
        Uri.parse('$baseUrl/received'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        final messages = data.map((json) => Message.fromJson(json)).toList();
        print('Parsed ${messages.length} messages');
        return messages;
      } else {
        print('Error response: ${response.body}');
        throw Exception('Error ${response.statusCode}: ${response.body}');
      }
    } catch (e, stackTrace) {
      print('Error getting messages: $e');
      print('Stack trace: $stackTrace'); 
      throw Exception('Error de conexión: $e');
    }
  }


  static Future<List<Message>> getSentMessages(String token) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/sent'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Message.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load sent messages');
      }
    } catch (e) {
      print('Error getting sent messages: $e');
      throw Exception('Error de conexión');
    }
  }

 
   

  static Future<List<Message>> getMessageHistory(String token, int otherUserId) async {
    try {
      print('Fetching chat history with user $otherUserId');
      final response = await http.get(
        Uri.parse('$baseUrl/history/$otherUserId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Message.fromJson(json)).toList();
      } else {
        throw Exception('Error ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      print('Error getting chat history: $e');
      throw Exception('Error de conexión: $e');
    }
  }

  static Future<List<Message>> getConversations(String token) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/conversations'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Message.fromJson(json)).toList();
      } else {
        throw Exception('Error al cargar conversaciones');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  static Future<void> sendMessage(String token, int receiverId, String content) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/send'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'receiverId': receiverId,
          'content': content,
        }),
      );

      if (response.statusCode != 201) {
        throw Exception('Error al enviar mensaje');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }
}