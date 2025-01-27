import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _usernameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _ageCtrl = TextEditingController();
  final _locationCtrl = TextEditingController();

  Future<void> _register() async {
    final url = Uri.parse('http://localhost:5000/api/users/register');
    final body = jsonEncode({
      'username': _usernameCtrl.text,
      'email': _emailCtrl.text,
      'password': _passwordCtrl.text,
      'age': _ageCtrl.text,
      'location': _locationCtrl.text,
    });

    try {
      final response = await http.post(url,
          headers: {'Content-Type': 'application/json'}, body: body);

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Usuario registrado con éxito')),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${response.body}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error de red: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registro de Usuario'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(children: [
          TextField(controller: _usernameCtrl, decoration: InputDecoration(labelText: 'Usuario')),
          TextField(controller: _emailCtrl, decoration: InputDecoration(labelText: 'Correo')),
          TextField(controller: _passwordCtrl, obscureText: true, decoration: InputDecoration(labelText: 'Contraseña')),
          TextField(controller: _ageCtrl, decoration: InputDecoration(labelText: 'Edad'), keyboardType: TextInputType.number),
          TextField(controller: _locationCtrl, decoration: InputDecoration(labelText: 'Ubicación')),
          SizedBox(height: 20),
          ElevatedButton(onPressed: _register, child: Text('Registrarse')),
        ]),
      ),
    );
  }
}