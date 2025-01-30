import 'package:flutter/material.dart';
import '../services/message_service.dart';
import '../models/message_model.dart';
import 'conversation_screen.dart';

class ConversationListScreen extends StatefulWidget {
  final String token;

  const ConversationListScreen({Key? key, required this.token}) : super(key: key);

  @override
  _ConversationListScreenState createState() => _ConversationListScreenState();
}

class _ConversationListScreenState extends State<ConversationListScreen> {
  List<Message> _conversations = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadConversations();
  }

  Future<void> _loadConversations() async {
    setState(() => _isLoading = true);
    try {
      final messages = await MessageService.getReceivedMessages(widget.token);
      setState(() => _conversations = messages);
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
      appBar: AppBar(title: Text('Conversaciones')),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadConversations,
              child: _conversations.isEmpty
                  ? Center(child: Text('No hay mensajes'))
                  : ListView.builder(
                      itemCount: _conversations.length,
                      itemBuilder: (context, index) {
                        final message = _conversations[index];
                        final username = message.sender?['username'] ?? 'Usuario';
                        
                        return Card(
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Theme.of(context).primaryColor,
                              child: Text(
                                username[0].toUpperCase(),
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            title: Text(username),
                            subtitle: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    message.content,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                if (!message.read)
                                  Container(
                                    margin: EdgeInsets.only(left: 8),
                                    width: 8,
                                    height: 8,
                                    decoration: BoxDecoration(
                                      color: Colors.blue,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                              ],
                            ),
                            trailing: Text(
                              _formatDate(message.createdAt),
                              style: TextStyle(color: Colors.grey),
                            ),
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ConversationScreen(
                                  token: widget.token,
                                  otherUserId: message.senderId,
                                  otherUsername: username,
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

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    if (date.year == now.year && date.month == now.month) {
      if (date.day == now.day) {
        return '${date.hour}:${date.minute.toString().padLeft(2, '0')}';
      }
      if (date.day == now.day - 1) {
        return 'Ayer';
      }
    }
    return '${date.day}/${date.month}/${date.year}';
  }
}