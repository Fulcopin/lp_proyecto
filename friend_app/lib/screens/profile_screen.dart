import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../services/storege_service.dart';
import '../services/user_service.dart';
import '../widgets/profile_image_widget.dart';

class ProfileScreen extends StatefulWidget {
  final String userId;

  const ProfileScreen({Key? key, required this.userId}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  final _interestsController = TextEditingController();
  bool _isLoading = false;
  String? _profileImageUrl;
  File? _imageFile;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    setState(() => _isLoading = true);
    try {
      final imageUrl = await StorageService.getProfileImage(widget.userId);
      if (mounted && imageUrl != null) {
        setState(() {
          _profileImageUrl = imageUrl;
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error loading profile: $e');
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
Future<void> _pickImage() async {
  final picker = ImagePicker();
  final XFile? image = await picker.pickImage(source: ImageSource.gallery);
  
  if (image != null && mounted) {
    try {
      setState(() => _isLoading = true);
      final imageUrl = await StorageService.uploadProfileImage(
        File(image.path),
        widget.userId,
      );
      
      if (mounted) {
        setState(() {
          _profileImageUrl = imageUrl;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mi Perfil'),
      ),
      body: _isLoading 
        ? Center(child: CircularProgressIndicator())
        : Form(
          key: _formKey,
          child: ListView(
            padding: EdgeInsets.all(16.0),
            children: [
              Center(
                child: Stack(
                  children: [
                    ProfileImageWidget(
                      imageUrl: _profileImageUrl,
                      size: 120,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.pink,
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: Icon(Icons.camera_alt, color: Colors.white),
                          onPressed: _pickImage,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: 'Descripción',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Este campo es requerido' : null,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _interestsController,
                decoration: InputDecoration(
                  labelText: 'Intereses (separados por coma)',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Este campo es requerido' : null,
              ),
              SizedBox(height: 20),
              ElevatedButton(
              onPressed: _isLoading ? null : () async {
                if (_formKey.currentState!.validate()) {
                  setState(() => _isLoading = true);
                  try {
                    final profileData = {
                      'description': _descriptionController.text,
                      'interests': _interestsController.text.split(','),
                     
                    };
                    
                    final result = await UserService.updateProfile(widget.userId, profileData);
                    
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Perfil actualizado')),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error: $e')),
                    );
                  } finally {
                    if (mounted) {
                      setState(() => _isLoading = false);
                    }
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

  @override
  void dispose() {
    _descriptionController.dispose();
    _interestsController.dispose();
    super.dispose();
  }
}