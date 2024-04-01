import 'package:flutter/material.dart';
import 'package:pravda_news/presentation/theme/app_theme.dart';

class ThemeNotifier extends ChangeNotifier {
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
