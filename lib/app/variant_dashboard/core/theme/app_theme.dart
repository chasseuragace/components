import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData build() {
    return ThemeData(
      useMaterial3: true,
      colorSchemeSeed: Colors.deepPurple,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        elevation: 4,
        titleTextStyle: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  static const Color warningLight = Color(0xFFD97706);
  static const Color successLight = Color(0xFF059669);
}
