import 'package:flutter/material.dart';
import '/services/friend_service.dart';
class SendFriendRequestScreen extends StatefulWidget {
  final String token;

  const SendFriendRequestScreen({
    Key? key, 
    required this.token
  }) : super(key: key);

  @override
  _SendFriendRequestScreenState createState() => _SendFriendRequestScreenState();
}

class _SendFriendRequestScreenState extends State<SendFriendRequestScreen> {
  final _friendIdController = TextEditingController();
  bool _isLoading = false;

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
              decoration: InputDecoration(
                labelText: 'ID del Amigo',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _isLoading ? null : () async {
                final friendId = _friendIdController.text;
                if (friendId.isNotEmpty) {
                  setState(() => _isLoading = true);
                  try {
                    await FriendService.sendFriendRequest(friendId, widget.token);
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Solicitud enviada con éxito')),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(e.toString())),
                    );
                  } finally {
                    setState(() => _isLoading = false);
                  }
                }
              },
              child: _isLoading 
                  ? CircularProgressIndicator(color: Colors.white)
                  : Text('Enviar Solicitud'),
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