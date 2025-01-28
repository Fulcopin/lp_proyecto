import 'package:flutter/material.dart';
import 'profile_screen.dart';
import 'search_screen.dart';
import 'friend_list_screen.dart';
import 'send_message_screen.dart';
import 'receive_messages_screen.dart';

class DashboardScreen extends StatelessWidget {
  final String token;
  final String userId;  // Add userId parameter

  const DashboardScreen({
    Key? key,
    required this.token,
    required this.userId,  // Add to constructor
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dating App'),
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
          child: GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            children: [
              _buildFeatureCard(
                context,
                'Perfil',
                Icons.person,
                Colors.green,
                () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => ProfileScreen()),
                ),
              ),
              _buildFeatureCard(
                context,
                'Buscar',
                Icons.search,
                Colors.orange,
                () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => SearchScreen(token: token)),
                ),
              ),
              _buildFeatureCard(
                context,
                'Amigos',
                Icons.people,
                Colors.purple,
                () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => FriendListScreen()),
                ),
              ),
              _buildFeatureCard(
                context,
                'Mensajes',
                Icons.message,
                Colors.teal,
                () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ReceiveMessagesScreen(userId: userId),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }




  Widget _buildFeatureCard(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 48,
              color: color,
            ),
            SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}