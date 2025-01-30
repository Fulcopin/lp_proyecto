import 'package:flutter/material.dart';
import '../services/message_service.dart';
class SendMessageScreen extends StatefulWidget {
  final String token;
  final int receiverId;
  final String receiverName;

  const SendMessageScreen({
    Key? key, 
    required this.token,
    required this.receiverId,
    required this.receiverName,
  }) : super(key: key);

  @override
  _SendMessageScreenState createState() => _SendMessageScreenState();
}

class _SendMessageScreenState extends State<SendMessageScreen> {
  final _messageController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mensaje para ${widget.receiverName}'),
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).primaryColor.withOpacity(0.1),
              Colors.white,
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      ListTile(
                        leading: CircleAvatar(
                          child: Text(widget.receiverName[0].toUpperCase()),
                          backgroundColor: Theme.of(context).primaryColor,
                        ),
                        title: Text(widget.receiverName),
                        subtitle: Text('ID: ${widget.receiverId}'),
                      ),
                      Divider(),
                      TextField(
                        controller: _messageController,
                        decoration: InputDecoration(
                          labelText: 'Mensaje',
                          prefixIcon: Icon(Icons.message),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        maxLines: 3,
                      ),
                      SizedBox(height: 20),
                      ElevatedButton.icon(
                        onPressed: _isLoading ? null : _sendMessage,
                        icon: _isLoading 
                          ? SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(color: Colors.white),
                            )
                          : Icon(Icons.send),
                        label: Text(_isLoading ? 'Enviando...' : 'Enviar Mensaje'),
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(double.infinity, 50),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _sendMessage() async {
    if (_messageController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Por favor escribe un mensaje')),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      await MessageService.sendMessage(
        widget.token,
        widget.receiverId,
        _messageController.text,
      );

      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Mensaje enviado correctamente'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al enviar mensaje: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }
}