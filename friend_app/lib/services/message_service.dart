import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/message_model.dart';

class MessageService {
  static const String baseUrl = 'http://localhost:5000/api';

  static Future<List<Message>> getReceivedMessages(String userId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/messages/received/$userId'),
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body) as List;
      return data.map((e) => Message.fromJson(e)).toList();
    } else {
      throw Exception('Error al obtener mensajes recibidos: ${response.body}');
    }
  }

  static Future<List<Message>> getSentMessages(String userId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/messages/sent/$userId'),
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body) as List;
      return data.map((e) => Message.fromJson(e)).toList();
    } else {
      throw Exception('Error al obtener mensajes enviados: ${response.body}');
    }
  }

  static Future<void> sendMessage(String receiverId, String content) async {
    final response = await http.post(
      Uri.parse('$baseUrl/messages/send'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'receiverId': receiverId, 'content': content}),
    );
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Error al enviar mensaje');
    }
  }
}