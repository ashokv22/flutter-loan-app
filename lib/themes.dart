import 'package:flutter/material.dart';

// Light theme
final lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: const Color.fromARGB(255, 3, 71, 244),
  colorScheme: const ColorScheme.light(
    secondary: Colors.green, // Set the accent color here
  ),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: Colors.black),
    bodyMedium: TextStyle(color: Colors.black),
    bodySmall: TextStyle(color: Colors.black),
    displayLarge: TextStyle(color: Colors.black),
    displayMedium: TextStyle(color: Colors.black87)
  ),
  iconTheme: const IconThemeData(
    color: Colors.white,
  )
);

// Dark theme
final darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: const Color.fromARGB(255, 3, 71, 244), 
  colorScheme: const ColorScheme.dark(
    secondary: Colors.green
  ),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: Colors.white),
    bodyMedium: TextStyle(color: Colors.white),
    bodySmall: TextStyle(color: Colors.white),
    displayLarge: TextStyle(color: Colors.white),
    displayMedium: TextStyle(color: Colors.white),
  ),
);

// Function to get the system default theme
ThemeData getSystemDefaultTheme(Brightness platformBrightness) {
  return platformBrightness == Brightness.dark ? darkTheme : lightTheme;
}