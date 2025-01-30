import 'package:flutter/material.dart';
import '../services/message_service.dart';
import '../models/message_model.dart';
import 'chat_screen.dart';

class MessageListScreen extends StatefulWidget {
  final String token;

  const MessageListScreen({Key? key, required this.token}) : super(key: key);

  @override
  _MessageListScreenState createState() => _MessageListScreenState();
}

class _MessageListScreenState extends State<MessageListScreen> {
  List<Message> _messages = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  Future<void> _loadMessages() async {
    setState(() => _isLoading = true);
    try {
      final messages = await MessageService.getReceivedMessages(widget.token);
      setState(() => _messages = messages);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Mensajes')),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadMessages,
              child: ListView.builder(
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final message = _messages[index];
                  return Card(
                    margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: ListTile(
                      leading: CircleAvatar(
                        child: Text(message.sender?['username']?[0].toUpperCase() ?? '?'),
                      ),
                      title: Text(message.sender?['username'] ?? 'Usuario'),
                      subtitle: Text(
                        message.content,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: Text(
                        message.createdAt.toString().split(' ')[0],
                        style: TextStyle(color: Colors.grey),
                      ),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatScreen(
                            token: widget.token,
                            otherUserId: message.senderId,
                            otherUserName: message.sender?['username'] ?? 'Usuario',
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}