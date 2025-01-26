import 'package:flutter/material.dart';
import '../services/message_service.dart';
import '../models/message_model.dart';

class ReceiveMessagesScreen extends StatefulWidget {
  final String userId;

  const ReceiveMessagesScreen({
    Key? key,
    required this.userId,
  }) : super(key: key);

  @override
  _ReceiveMessagesScreenState createState() => _ReceiveMessagesScreenState();
}

class _ReceiveMessagesScreenState extends State<ReceiveMessagesScreen> {
  late Future<List<Message>> _messages;

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  void _loadMessages() {
    _messages = MessageService.getReceivedMessages(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mensajes Recibidos'),
      ),
      body: FutureBuilder<List<Message>>(
        future: _messages,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          final messages = snapshot.data!;
          return RefreshIndicator(
            onRefresh: () async {
              setState(() {
                _messages = MessageService.getReceivedMessages(widget.userId);
              });
            },
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                return ListTile(
                  title: Text('De: ${message.senderId}'),
                  subtitle: Text(message.content),
                  trailing: Text(
                    '${message.timestamp.day}/${message.timestamp.month}/${message.timestamp.year}',
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}