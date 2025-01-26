import 'package:flutter/material.dart';
import '../services/user_service.dart';
import '../models/user_model.dart';

class SearchUsersScreen extends StatefulWidget {
  @override
  _SearchUsersScreenState createState() => _SearchUsersScreenState();
}

class _SearchUsersScreenState extends State<SearchUsersScreen> {
  final _ageController = TextEditingController();
  final _locationController = TextEditingController();
  List<User> _users = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Buscar Usuarios'),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: _ageController,
                  decoration: InputDecoration(labelText: 'Edad'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: _locationController,
                  decoration: InputDecoration(labelText: 'Ubicación'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    try {
                      final users = await UserService.searchUsers({
                        'age': _ageController.text,
                        'location': _locationController.text,
                      });
                      setState(() {
                        _users = users;
                      });
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error: $e')),
                      );
                    }
                  },
                  child: Text('Buscar'),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _users.length,
              itemBuilder: (context, index) {
                final user = _users[index];
                return ListTile(
                  title: Text(user.username),
                  subtitle: Text('${user.age} años - ${user.location}'),
                  trailing: IconButton(
                    icon: Icon(Icons.person_add),
                    onPressed: () {
                      // Implementar lógica para enviar solicitud de amistad
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}