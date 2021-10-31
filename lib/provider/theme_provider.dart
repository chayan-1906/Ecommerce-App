import 'package:ecommerce_app/models/theme_preferences.dart';
import 'package:flutter/cupertino.dart';

class ThemeProvider with ChangeNotifier {
  ThemePreferences themePreferences = ThemePreferences();

  bool _darkTheme = false;

  bool get darkTheme => _darkTheme;

  set darkTheme(bool theme) {
    _darkTheme = theme;
    themePreferences.setDarkTheme(theme);
    notifyListeners();
  }
}
