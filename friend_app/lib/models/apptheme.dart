import 'package:flutter/material.dart';

class AppTheme {
  static const Color primary = Color(0xFF1976D2);
  static const Color secondary = Color(0xFF4CAF50);
  static const Color accent = Color(0xFFE91E63);
  static const Color background = Color(0xFFF5F5F5);

  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF1976D2), Color(0xFF64B5F6)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const BoxShadow cardShadow = BoxShadow(
    color: Colors.black12,
    blurRadius: 8,
    offset: Offset(0, 4),
  );

  static final cardShape = RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(15),
  );

  static const textTheme = {
    'headline1': TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.bold,
      color: Color(0xFF2C3E50),
    ),
    'headline2': TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: Color(0xFF2C3E50),
    ),
    'subtitle1': TextStyle(
      fontSize: 18,
      color: Color(0xFF95A5A6),
    ),
    'body1': TextStyle(
      fontSize: 16,
      color: Color(0xFF2C3E50),
    ),
  };

  static const inputDecoration = InputDecorationTheme(
    filled: true,
    fillColor: Colors.white,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(12)),
      borderSide: BorderSide.none,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(12)),
      borderSide: BorderSide.none,
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(12)),
      borderSide: BorderSide(color: primary, width: 2),
    ),
  );

  static const buttonTheme = ButtonStyle(
    padding: MaterialStatePropertyAll<EdgeInsets>(
      EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    ),
    shape: MaterialStatePropertyAll<RoundedRectangleBorder>(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    ),
  );
}