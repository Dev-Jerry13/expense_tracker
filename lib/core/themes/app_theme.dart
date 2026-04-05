import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData light = ThemeData(
    colorSchemeSeed: Colors.teal,
    brightness: Brightness.light,
    useMaterial3: true,
    cardTheme: const CardThemeData(
      elevation: 0,
      margin: EdgeInsets.all(0),
    ),
  );

  static ThemeData dark = ThemeData(
    colorSchemeSeed: Colors.teal,
    brightness: Brightness.dark,
    useMaterial3: true,
  );
}
