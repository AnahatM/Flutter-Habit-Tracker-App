import 'package:flutter/material.dart';
import 'package:minimalist_habit_tracker/themes/dark_mode.dart';
import 'package:minimalist_habit_tracker/themes/light_mode.dart';

class ThemeProvider extends ChangeNotifier {
  // Initially light mode
  ThemeData _themeData = lightMode;

  // Get the current theme
  ThemeData get themeData => _themeData;

  // Is the current theme dark
  bool get isDarkMode => _themeData == darkMode;

  // Set the theme
  set themeData(ThemeData themeData) {
    _themeData = themeData;
    notifyListeners();
  }

  // Toggle the theme
  void toggleTheme() {
    _themeData = isDarkMode ? lightMode : darkMode;
    notifyListeners();
  }
}
