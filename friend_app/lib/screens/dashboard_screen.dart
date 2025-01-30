import 'package:flutter/material.dart';
import 'profile_screen.dart';
import 'search_screen.dart';
import 'friend_list_screen.dart';
import 'messages_screen.dart';
class DashboardScreen extends StatefulWidget {
  final String token;
  final String userId;

  const DashboardScreen({
    Key? key, 
    required this.token,
    required this.userId,
  }) : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Left Sidebar
          Container(
            width: 250,
            color: Theme.of(context).primaryColor,
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    'Encuentra tu Match',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                _buildMenuItem(
                  context,
                  'Perfil',
                  Icons.person_outline,
                  0,
                ),
                _buildMenuItem(
                  context,
                  'Búsqueda',
                  Icons.search_outlined,
                  1,
                ),
                _buildMenuItem(
                  context,
                  'Matches',
                  Icons.favorite_border,
                  2,
                ),
                _buildMenuItem(
                  context,
                  'Mensajes',
                  Icons.message_outlined,
                  3,
                ),
                Spacer(),
                _buildMenuItem(
                  context,
                  'Cerrar Sesión',
                  Icons.exit_to_app,
                  4,
                ),
              ],
            ),
          ),
          // Main Content
          Expanded(
            child: Container(
              color: Colors.grey[100],
              child: _buildContent(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context,
    String title,
    IconData icon,
    int index,
  ) {
    final isSelected = _selectedIndex == index;
    return ListTile(
      leading: Icon(icon, color: isSelected ? Colors.white : Colors.white70),
      title: Text(
        title,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.white70,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      onTap: () {
        if (index == 4) {
          // Logout
          Navigator.of(context).pushReplacementNamed('/login');
          return;
        }
        setState(() => _selectedIndex = index);
      },
      selected: isSelected,
      selectedTileColor: Colors.white.withOpacity(0.1),
    );
  }

  Widget _buildContent() {
    switch (_selectedIndex) {
      case 0:
        return ProfileScreen(userId: widget.userId);
      case 1:
        return SearchScreen(token: widget.token);
      case 2:
        return FriendListScreen(token: widget.token);
      case 3:
        return MessagesScreen(token: widget.token);
      default:
        return Center(
          child: Text(
            'Bienvenido',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
        );
    }
  }
}