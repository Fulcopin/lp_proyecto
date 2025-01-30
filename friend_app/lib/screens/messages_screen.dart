import 'package:flutter/material.dart';
import '../services/message_service.dart';
import '../models/message_model.dart';
import 'chat_screen.dart'; 
class MessagesScreen extends StatefulWidget {
  final String token;

  const MessagesScreen({Key? key, required this.token}) : super(key: key);

  @override
  _MessagesScreenState createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> with SingleTickerProviderStateMixin {
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
    print('Fetching messages...');
    final received = await MessageService.getReceivedMessages(widget.token);
    print('Received messages: ${received.length}');
    final sent = await MessageService.getSentMessages(widget.token);
    print('Sent messages: ${sent.length}');
    
    setState(() {
      _receivedMessages = received;
      _sentMessages = sent;
    });
  } catch (e, stackTrace) {
    print('Error loading messages: $e');
    print('Stack trace: $stackTrace');
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
            Tab(text: 'Enviados'),
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
    child: _receivedMessages.isEmpty
        ? Center(child: Text('No hay mensajes'))
        : ListView.builder(
            itemCount: _receivedMessages.length,
            itemBuilder: (context, index) {
              final message = _receivedMessages[index];
              final username = message.sender?['username'] ?? 'Usuario ${message.senderId}';
              
              return Card(
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: InkWell(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatScreen(
                        token: widget.token,
                        otherUserId: message.senderId,
                        otherUserName: username,
                      ),
                    ),
                  ).then((_) => _loadMessages()),
                  child: Padding(
                    padding: EdgeInsets.all(12),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: Theme.of(context).primaryColor,
                          child: Text(
                            username[0].toUpperCase(),
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    username,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  Text(
                                    _formatDate(message.createdAt),
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 4),
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      message.content,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: message.read ? Colors.grey : Colors.black,
                                      ),
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
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
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
  Widget _buildSendMessage() {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            controller: _receiverController,
            decoration: InputDecoration(
              labelText: 'ID del destinatario',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
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
      if (_receiverController.text.isEmpty || _messageController.text.isEmpty) {
        throw Exception('Por favor complete todos los campos');
      }

      await MessageService.sendMessage(
        widget.token,
        int.parse(_receiverController.text),
        _messageController.text,
      );

      _messageController.clear();
      _receiverController.clear();
      await _loadMessages();

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