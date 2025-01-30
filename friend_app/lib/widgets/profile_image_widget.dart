import 'package:flutter/material.dart';

class ProfileImageWidget extends StatelessWidget {
  final String? imageUrl;
  final double size;

  const ProfileImageWidget({
    Key? key,
    this.imageUrl,
    this.size = 100,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.grey[200],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(size / 2),
        child: imageUrl != null
            ? Image.network(
                imageUrl!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => _defaultImage(),
              )
            : Image.asset(
                'images/default_profile.jpg',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => _defaultImage(),
              ),
      ),
    );
  }

  Widget _defaultImage() {
    return Icon(
      Icons.person,
      size: size * 0.6,
      color: Colors.grey[400],
    );
  }
}