import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../services/friend_service.dart';  // Add this import

class UserCard extends StatelessWidget {
  final dynamic user;
  final String token;

  const UserCard({
    Key? key,
    required this.user,
    required this.token,
  }) : super(key: key);

  Future<void> _sendFriendRequest(BuildContext context) async {
    try {
      print('Sending request to user: ${user['id']}');
      await FriendService.sendFriendRequest(user['id'].toString(), token);
      
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Solicitud enviada'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const CircleAvatar(child: Icon(Icons.person)),
        title: Text(user['username'] ?? 'Usuario'),
        subtitle: Text('${user['age']} años - ${user['location']}'),
        trailing: IconButton(
          icon: const Icon(Icons.person_add),
          onPressed: () => _sendFriendRequest(context),
        ),
      ),
    );
  }
}