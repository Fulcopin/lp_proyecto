import 'package:flutter/material.dart';
import '/services/friend_service.dart';

class SendFriendRequestScreen extends StatefulWidget {
  @override
  _SendFriendRequestScreenState createState() => _SendFriendRequestScreenState();
}

class _SendFriendRequestScreenState extends State<SendFriendRequestScreen> {
  final _friendIdController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Enviar Solicitud de Amistad'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _friendIdController,
              decoration: InputDecoration(labelText: 'ID del Amigo'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                final friendId = _friendIdController.text;
                if (friendId.isNotEmpty) {
                  try {
                    await FriendService.sendFriendRequest(friendId);
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Solicitud enviada con éxito')),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(e.toString())),
                    );
                  }
                }
              },
              child: Text('Enviar Solicitud'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _friendIdController.dispose();
    super.dispose();
  }
}