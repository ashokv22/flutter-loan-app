import 'package:flutter/material.dart';

class ColorAppBar {

  static const Map<String, Color> gradientStartColors = {
    "lead": Color(0xFF00861D),
    "pending for cibil approval": Colors.deepOrange,
    "submitted - credit decision pending": Colors.deepPurple,
    "pre lead": Color.fromARGB(255, 173, 1, 185),
    "rejected": Color.fromARGB(255, 254, 18, 30),
    "credit - rework": Color.fromARGB(255, 255, 250, 12),
    "default": Colors.white,
  };

  static LinearGradient getGradient(String stage, bool isDarkTheme) {
    Color startColor = gradientStartColors[stage.toLowerCase()] ?? gradientStartColors["default"]!;
    Color endColor = isDarkTheme ? Colors.black : Colors.white;

    return LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [startColor, endColor],
    );
  }
}
