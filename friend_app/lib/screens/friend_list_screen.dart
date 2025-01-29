import 'package:flutter/material.dart';
import '../services/friend_service.dart';
import '../models/friend_request.dart';
import '../models/user_model.dart';

class FriendListScreen extends StatefulWidget {
  final String token;

  const FriendListScreen({
    Key? key,
    required this.token,
  }) : super(key: key);

  @override
  _FriendListScreenState createState() => _FriendListScreenState();
}

class _FriendListScreenState extends State<FriendListScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<FriendRequest> _pendingRequests = [];
  List<User> _friends = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadFriendsData();
  }

  Future<void> _loadFriendsData() async {
    setState(() => _isLoading = true);
    try {
      final requests = await FriendService.getPendingRequests(widget.token);
      final friends = await FriendService.getFriendsList(widget.token);
      setState(() {
        _pendingRequests = requests;
        _friends = friends;
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
        title: Text('Amigos'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'Solicitudes'),
            Tab(text: 'Amigos'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildPendingRequestsTab(),
          _buildFriendsListTab(),
        ],
      ),
    );
  }

  Widget _buildPendingRequestsTab() {
  if (_isLoading) {
    return Center(child: CircularProgressIndicator());
  }
  return RefreshIndicator(
    onRefresh: _loadFriendsData,
    child: _pendingRequests.isEmpty
        ? Center(child: Text('No hay solicitudes pendientes'))
        : ListView.builder(
            itemCount: _pendingRequests.length,
            itemBuilder: (context, index) {
              final request = _pendingRequests[index];
              return Card(
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  leading: CircleAvatar(
                    child: Icon(Icons.person),
                  ),
                  title: Text('Solicitud de: ${request.sender.username}'),
                  subtitle: Text(
                    'Enviado: ${request.createdAt.toString().split('.')[0]}'
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.check, color: Colors.green),
                        onPressed: () => _respondToRequest(request.id.toString(), true),
                      ),
                      IconButton(
                        icon: Icon(Icons.close, color: Colors.red),
                        onPressed: () => _respondToRequest(request.id.toString(), false),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
  );
}

  Widget _buildFriendsListTab() {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    return RefreshIndicator(
      onRefresh: _loadFriendsData,
      child: _friends.isEmpty
          ? Center(child: Text('No tienes amigos aún'))
          : ListView.builder(
              itemCount: _friends.length,
              itemBuilder: (context, index) {
                final friend = _friends[index];
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    leading: CircleAvatar(
                      child: Text(friend.username[0].toUpperCase()),
                      backgroundColor: Theme.of(context).primaryColor,
                    ),
                    title: Text(friend.username),
                    subtitle: Text('${friend.age} años - ${friend.location}'),
                    trailing: IconButton(
                      icon: Icon(Icons.message),
                      onPressed: () {
                        // Navigate to chat screen
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }

Future<void> _respondToRequest(String requestId, bool accept) async {
    try {
      await FriendService.respondToRequest(requestId, accept, widget.token);
      await _loadFriendsData();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(accept ? 'Solicitud aceptada' : 'Solicitud rechazada'),
          backgroundColor: accept ? Colors.green : Colors.red,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}