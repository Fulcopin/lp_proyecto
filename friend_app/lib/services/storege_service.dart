import 'dart:io';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:convert';

class StorageService {
 static final cloudinary = CloudinaryPublic(
    'dpczd4ufe',           // Cloud name from dashboard
    'ml_default',  // API Key from Settings > Upload > Upload Presets
  );
  static final FirebaseStorage _storage = FirebaseStorage.instance;
  static final FirebaseDatabase _database = FirebaseDatabase.instance;

  static Future<String> _uploadToCloudinary(File image) async {
    try {
      CloudinaryResponse response = await cloudinary.uploadFile(
        CloudinaryFile.fromFile(
          image.path,
          folder: 'uploads',
          resourceType: CloudinaryResourceType.Auto,
          //publicId: 'profile_${DateTime.now().millisecondsSinceEpoch}',
        ),
      );
      print('Cloudinary Upload Success: ${response.secureUrl}');
      return response.secureUrl;
    } catch (e) {
      print('Cloudinary Error Details: $e');
      throw Exception('Cloudinary upload error: $e');
    }
  }



 

static Future<String> uploadProfileImage(File image, String userId) async {
  try {
    // Upload to Cloudinary
    CloudinaryResponse response = await cloudinary.uploadFile(
      CloudinaryFile.fromFile(
        image.path,
        folder: 'uploads',
        resourceType: CloudinaryResourceType.Image,
      ),
    );

    // Store in main user data
    await _database
        .ref()
        .child('users')
        .child(userId)
        .update({
          'profileImage': response.secureUrl,
          'updatedAt': ServerValue.timestamp,
        });

    return response.secureUrl;
  } catch (e) {
    print('Upload Error: $e');
    throw Exception('Error uploading image: $e');
  }
}

static Future<String?> getProfileImage(String userId) async {
  try {
    final snapshot = await _database
        .ref()
        .child('users')
        .child(userId)
        .child('profileImage')
        .get();
    
    return snapshot.value as String?;
  } catch (e) {
    print('Error getting profile image: $e');
    return null;
  }
}
 
  static Future<Map<String, dynamic>> _saveMetadataToFirebase({
    required String userId,
    required String imageUrl,
  }) async {
    try {
      final imageId = DateTime.now().millisecondsSinceEpoch.toString();
      final metadata = {
        'imageId': imageId,
        'userId': userId,
        'imageUrl': imageUrl,
        'createdAt': DateTime.now().toIso8601String(),
      };

      await _database
          .ref()
          .child('users/$userId/profile')
          .update({'profileImage': imageUrl});

      await _storage
          .ref()
          .child('profile_photos_metadata/$userId/$imageId')
          .putString(json.encode(metadata));

      return metadata;
    } catch (e) {
      throw Exception('Firebase save error: $e');
    }
  }
}