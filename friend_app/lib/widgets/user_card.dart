import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UserCard extends StatelessWidget {
  final dynamic user;
  final String token;

  const UserCard({
    Key? key,
    required this.user,
    required this.token,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: CircleAvatar(
          child: Text(user['username'][0].toUpperCase()),
        ),
        title: Text(user['username']),
        subtitle: Text('${user['age']} años - ${user['location']}'),
        trailing: IconButton(
          icon: Icon(Icons.person_add),
          onPressed: () async {
            try {
              final response = await http.post(
                Uri.parse('http://localhost:5000/api/friends/request/${user['id']}'),
                headers: {
                  'Authorization': 'Bearer $token'
                },
              );

              if (response.statusCode == 201) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Solicitud enviada')),
                );
              }
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error: $e')),
              );
            }
          },
        ),
      ),
    );
  }
}