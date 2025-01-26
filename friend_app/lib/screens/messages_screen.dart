import 'package:flutter/material.dart';
import '../services/message_service.dart';
import '../models/message_model.dart';

class MessagesScreen extends StatefulWidget {
  @override
  _MessagesScreenState createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> 
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _messageController = TextEditingController();
  final _receiverController = TextEditingController();
  List<Message> _receivedMessages = [];
  List<Message> _sentMessages = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadMessages();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _messageController.dispose();
    _receiverController.dispose();
    super.dispose();
  }

  Future<void> _loadMessages() async {
    setState(() => _isLoading = true);
    try {
      final received = await MessageService.getReceivedMessages('currentUserId');
      final sent = await MessageService.getSentMessages('currentUserId');
      setState(() {
        _receivedMessages = received;
        _sentMessages = sent;
      });
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
      appBar: AppBar(
        title: Text('Mensajes'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'Recibidos'),
            Tab(text: 'Enviar'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildReceivedMessages(),
          _buildSendMessage(),
        ],
      ),
    );
  }

  Widget _buildReceivedMessages() {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    return RefreshIndicator(
      onRefresh: _loadMessages,
      child: ListView.builder(
        itemCount: _receivedMessages.length,
        itemBuilder: (context, index) {
          final message = _receivedMessages[index];
          return ListTile(
            title: Text('De: ${message.senderId}'),
            subtitle: Text(message.content),
            trailing: Text(message.timestamp.toString()),
          );
        },
      ),
    );
  }

  Widget _buildSendMessage() {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            controller: _receiverController,
            decoration: InputDecoration(
              labelText: 'Para',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 10),
          TextField(
            controller: _messageController,
            decoration: InputDecoration(
              labelText: 'Mensaje',
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
          ),
          SizedBox(height: 10),
          ElevatedButton.icon(
            onPressed: _sendMessage,
            icon: Icon(Icons.send),
            label: Text('Enviar'),
          ),
        ],
      ),
    );
  }

  Future<void> _sendMessage() async {
  try {
    await MessageService.sendMessage(
      _receiverController.text,  // receiverId
      _messageController.text,   // content
    );
    _messageController.clear();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Mensaje enviado')),
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error: $e')),
    );
  }
}
}