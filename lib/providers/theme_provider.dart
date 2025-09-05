import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/app_theme.dart';

class ThemeProvider extends ChangeNotifier {
  String _currentTheme = 'system';
  ThemeMode _themeMode = ThemeMode.system;

  String get currentTheme => _currentTheme;
  ThemeMode get themeMode => _themeMode;

  ThemeProvider() {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    _currentTheme = prefs.getString('theme') ?? 'system';
    _updateThemeMode();
    notifyListeners();
  }

  Future<void> setTheme(String theme) async {
    _currentTheme = theme;
    _updateThemeMode();
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('theme', theme);
    
    notifyListeners();
  }

  void _updateThemeMode() {
    switch (_currentTheme) {
      case 'light':
        _themeMode = ThemeMode.light;
        break;
      case 'dark':
        _themeMode = ThemeMode.dark;
        break;
      case 'system':
      default:
        _themeMode = ThemeMode.system;
        break;
    }
  }

  ThemeData getTheme(BuildContext context) {
    switch (_currentTheme) {
      case 'light':
        return AppTheme.lightTheme;
      case 'dark':
        return AppTheme.darkTheme;
      case 'system':
      default:
        return Theme.of(context).brightness == Brightness.dark
            ? AppTheme.darkTheme
            : AppTheme.lightTheme;
    }
  }

  bool get isDarkMode {
    switch (_currentTheme) {
      case 'light':
        return false;
      case 'dark':
        return true;
      case 'system':
      default:
        return false; // Bu durumda sistem teması kullanılacak
    }
  }

  String get themeDisplayName {
    switch (_currentTheme) {
      case 'light':
        return 'Açık Tema';
      case 'dark':
        return 'Koyu Tema';
      case 'system':
      default:
        return 'Sistem Teması';
    }
  }
}
