import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app_colors.dart';

class ThemeProvider extends ChangeNotifier {
  static const String _themeKey = 'theme_is_dark';
  bool _isDark = false;

  bool get isDark => _isDark;
  ThemeMode get themeMode => _isDark ? ThemeMode.dark : ThemeMode.light;

  ThemeProvider() {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    _isDark = prefs.getBool(_themeKey) ?? false;
    AppColors.updateTheme(_isDark);
    notifyListeners();
  }

  Future<void> toggleTheme(bool value) async {
    _isDark = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_themeKey, _isDark);
    AppColors.updateTheme(_isDark);
    notifyListeners();
  }
}
