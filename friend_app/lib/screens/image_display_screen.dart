import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import '../services/storege_service.dart';
class ImageDisplayScreen extends StatefulWidget {
  final File imageFile;
  final String userId;

  const ImageDisplayScreen({
    Key? key,
    required this.imageFile,
    required this.userId,
  }) : super(key: key);

  @override
  _ImageDisplayScreenState createState() => _ImageDisplayScreenState();
}

class _ImageDisplayScreenState extends State<ImageDisplayScreen> {
  bool _isLoading = false;
  String? _uploadedImageUrl;
  bool _mounted = true;

  @override
  void initState() {
    super.initState();
    _uploadImage();
  }

  @override
  void dispose() {
    _mounted = false;
    super.dispose();
  }

  Future<void> _uploadImage() async {
  if (!mounted) return;
  setState(() => _isLoading = true);
  
  try {
    final imageUrl = await StorageService.uploadProfileImage(
      widget.imageFile,
      widget.userId,
    );
    
    if (!mounted) return;
    setState(() {
      _uploadedImageUrl = imageUrl;
      _isLoading = false;
    });
  } catch (e) {
    if (!mounted) return;
    setState(() => _isLoading = false);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error: $e')),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Vista Previa'),
      ),
      body: Center(
        child: _isLoading 
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 20),
                Text('Cargando imagen...'),
              ],
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (_uploadedImageUrl != null)
                  CachedNetworkImage(
                    imageUrl: _uploadedImageUrl!,
                    height: 300,
                    width: 300,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => CircularProgressIndicator(),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context, _uploadedImageUrl),
                  child: Text('Confirmar'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pink,
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  ),
                ),
              ],
            ),
      ),
    );
  }
}