import 'package:pravda_news/theme/app_theme.dart';
import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeData? currentTheme = AppTheme.lightTheme();

  void setLightMode() {
    currentTheme = AppTheme.lightTheme();
    notifyListeners();
  }

  void setDarkMode() {
    currentTheme = AppTheme.darkTheme();
    notifyListeners();
  }
}
