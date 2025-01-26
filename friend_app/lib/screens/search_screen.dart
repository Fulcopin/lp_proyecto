import 'package:flutter/material.dart';
import '../services/user_service.dart';
import '../services/friend_service.dart';
import '../models/user_model.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _ageController = TextEditingController();
  final _locationController = TextEditingController();
  List<User> _users = [];
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Buscar Usuarios'),
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
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      TextField(
                        controller: _ageController,
                        decoration: InputDecoration(
                          labelText: 'Edad',
                          prefixIcon: Icon(Icons.calendar_today),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                      SizedBox(height: 16),
                      TextField(
                        controller: _locationController,
                        decoration: InputDecoration(
                          labelText: 'Ubicación',
                          prefixIcon: Icon(Icons.location_on),
                        ),
                      ),
                      SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: _isLoading ? null : _searchUsers,
                        icon: Icon(Icons.search),
                        label: Text('Buscar'),
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(double.infinity, 50),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16),
              Expanded(
                child: _isLoading
                    ? Center(child: CircularProgressIndicator())
                    : ListView.builder(
                        itemCount: _users.length,
                        itemBuilder: (context, index) {
                          final user = _users[index];
                          return Card(
                            margin: EdgeInsets.only(bottom: 8),
                            child: ListTile(
                              leading: CircleAvatar(
                                child: Text(user.username[0].toUpperCase()),
                                backgroundColor: Theme.of(context).primaryColor,
                              ),
                              title: Text(user.username),
                              subtitle: Text('${user.age} años - ${user.location}'),
                              trailing: IconButton(
                                icon: Icon(Icons.person_add),
                                onPressed: () => _sendFriendRequest(user.id),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _searchUsers() async {
    setState(() => _isLoading = true);
    try {
      final users = await UserService.searchUsers({
        'age': _ageController.text,
        'location': _locationController.text,
      });
      setState(() => _users = users);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _sendFriendRequest(String userId) async {
    try {
      await FriendService.sendFriendRequest(userId);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Solicitud enviada')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  void dispose() {
    _ageController.dispose();
    _locationController.dispose();
    super.dispose();
  }
}