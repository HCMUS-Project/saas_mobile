import 'package:flutter/material.dart';

ThemeData customTheme = ThemeData(
    appBarTheme: const AppBarTheme(
        scrolledUnderElevation: 0,
        color: Colors.white,
        iconTheme: IconThemeData(color: Color(0xFF161D3A))),

    colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.black,
        primary: Colors.white,
        secondary: Color(0xFF161D3A)),
    scaffoldBackgroundColor: Colors.white,
    textSelectionTheme: TextSelectionThemeData(
      
      cursorColor: Color(0xFF161D3A)),
    iconTheme: IconThemeData(color: Color(0xFF161D3A), size: 24),
    elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
      backgroundColor: Color(0xFF161D3A),
    )),
    textTheme: const TextTheme(
        titleLarge: TextStyle(color: Colors.black),
        titleMedium: TextStyle(color: Colors.black),
        titleSmall: TextStyle(color: Colors.black),
        bodyLarge: TextStyle(color: Colors.black),
        bodyMedium: TextStyle(color: Colors.black),
        bodySmall: TextStyle(color: Colors.black),
        labelLarge: TextStyle(color: Colors.black),
        labelMedium: TextStyle(color: Colors.black),
        labelSmall: TextStyle(color: Colors.black)));
