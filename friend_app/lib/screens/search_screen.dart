import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../widgets/user_card.dart';

class SearchScreen extends StatefulWidget {
  final String token;

  const SearchScreen({Key? key, required this.token}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  RangeValues _ageRange = RangeValues(18, 60);
  final _locationController = TextEditingController();
  List<dynamic> _users = [];
  bool _isLoading = false;

  Future<void> _searchUsers() async {
    setState(() => _isLoading = true);
    try {
      final params = {
        'location': _locationController.text, // Usa 'location'
        'edadMin': _ageRange.start.round().toString(),
        'edadMax': _ageRange.end.round().toString(),
      };

      print('Search params: $params');

      final uri = Uri.parse('http://127.0.0.1:5000/api/search')
          .replace(queryParameters: params);

      print('Request URL: $uri');

      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
        },
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() => _users = List.from(data));
      } else {
        // Manejar errores de la API
        print('Error en la API: ${response.statusCode}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error en la búsqueda: ${response.body}')), // Mostrar mensaje de error del backend
        );
      }
    } catch (e) {
      print('Error de búsqueda: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error de búsqueda: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Buscar Usuarios')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(
                      'Rango de Edad: ${_ageRange.start.round()} - ${_ageRange.end.round()}',
                      style: TextStyle(fontSize: 16),
                    ),
                    RangeSlider(
                      values: _ageRange,
                      min: 18,
                      max: 60,
                      divisions: 42,
                      labels: RangeLabels(
                        _ageRange.start.round().toString(),
                        _ageRange.end.round().toString(),
                      ),
                      onChanged: (values) => setState(() => _ageRange = values),
                    ),
                    TextField(
                      controller: _locationController,
                      decoration: InputDecoration(
                        labelText: 'Ubicación',
                        prefixIcon: Icon(Icons.location_on),
                      ),
                    ),
                    SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: _searchUsers,
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
                        return UserCard(user: user, token: widget.token);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}