import 'package:flutter/material.dart';

class MyTheme extends ChangeNotifier {

  ThemeMode _currentThemeMode = ThemeMode.system;

  ThemeMode get currentThemeMode => _currentThemeMode;

  void changeTheme(ThemeMode newTheme) {
    if (_currentThemeMode != newTheme) {
      _currentThemeMode = newTheme;
      notifyListeners();
    }
  }

}