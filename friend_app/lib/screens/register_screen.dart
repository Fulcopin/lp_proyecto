
import 'package:flutter/material.dart';
import '../services/user_service.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _ageController = TextEditingController();
  final _locationController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(16.0),
          children: [
            TextFormField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: 'Nombre de usuario'),
              validator: (value) {
                if (value?.isEmpty ?? true) {
                  return 'Por favor ingrese un nombre de usuario';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
              validator: (value) {
                if (value?.isEmpty ?? true) {
                  return 'Por favor ingrese un email';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Contraseña'),
              obscureText: true,
              validator: (value) {
                if (value?.isEmpty ?? true) {
                  return 'Por favor ingrese una contraseña';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _ageController,
              decoration: InputDecoration(labelText: 'Edad'),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value?.isEmpty ?? true) {
                  return 'Por favor ingrese su edad';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _locationController,
              decoration: InputDecoration(labelText: 'Ubicación'),
              validator: (value) {
                if (value?.isEmpty ?? true) {
                  return 'Por favor ingrese su ubicación';
                }
                return null;
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState?.validate() ?? false) {
                  try {
                    final userData = {
                      'username': _usernameController.text,
                      'email': _emailController.text,
                      'password': _passwordController.text,
                      'age': int.parse(_ageController.text),
                      'location': _locationController.text,
                    };
                    await UserService.registerUser(userData);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Usuario registrado exitosamente')),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error al registrar usuario: $e')),
                    );
                  }
                }
              },
              child: Text('Registrar'),
            ),
          ],
        ),
      ),
    );
  }
}