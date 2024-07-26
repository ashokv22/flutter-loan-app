import 'package:flutter/material.dart';

class ColorAppBar {
  static const Map<String, LinearGradient> gradientMap = {
    "Lead": LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Color(0xFF00861D), Colors.white],
    ),
    "Pending for CIBIL Approval": LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Colors.deepOrange, Colors.white],
    ),
    "Submitted - Credit Decision Pending": LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Colors.deepPurple, Colors.deepPurpleAccent],
    ),
    "Pre Lead": LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Color.fromARGB(255, 173, 1, 185), Colors.white],
    ),
    "Rejected": LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Color.fromARGB(255, 254, 18, 30), Colors.white],
    ),
    "Credit - Rework": LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Color.fromARGB(255, 255, 250, 12), Colors.white],
    ),
    "default": LinearGradient(
      colors: [Colors.white, Colors.white],
    ),
  };

  static LinearGradient getGradient(String stage) {
    return gradientMap[stage] ?? gradientMap["default"]!;
  }
}
