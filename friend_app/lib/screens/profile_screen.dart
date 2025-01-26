import 'package:flutter/material.dart';
import '../services/user_service.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  final _interestsController = TextEditingController();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mi Perfil'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(16.0),
          children: [
            TextFormField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Descripción'),
              maxLines: 3,
            ),
            TextFormField(
              controller: _interestsController,
              decoration: InputDecoration(labelText: 'Intereses'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  try {
                    final profileData = {
                      'description': _descriptionController.text,
                      'interests': _interestsController.text.split(','),
                    };
                    await UserService.updateProfile('userId', profileData);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Perfil actualizado')),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error: $e')),
                    );
                  }
                }
              },
              child: Text('Actualizar Perfil'),
            ),
          ],
        ),
      ),
    );
  }
}