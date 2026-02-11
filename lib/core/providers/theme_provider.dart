import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String _themeModeKey = 'theme_mode';

/// Theme mode state notifier with persistence
class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  final SharedPreferences _prefs;
  ThemeModeNotifier(this._prefs) : super(ThemeMode.system) {
    _loadTheme();
  }

  /// Load saved theme from SharedPreferences
  void _loadTheme() {
    final savedTheme = _prefs.getString(_themeModeKey);
    if (savedTheme != null) {
      state = _themeModeFromString(savedTheme);
    }
  }

  /// Save theme to SharedPreferences
  Future<void> _saveTheme(ThemeMode mode) async {
    await _prefs.setString(_themeModeKey, _themeModeToString(mode));
  }

  /// Set theme to light mode
  void setLightMode() {
    state = ThemeMode.light;
    _saveTheme(ThemeMode.light);
  }

  /// Set theme to dark mode
  void setDarkMode() {
    state = ThemeMode.dark;
    _saveTheme(ThemeMode.dark);
  }

  /// Set theme to follow system
  void setSystemMode() {
    state = ThemeMode.system;
    _saveTheme(ThemeMode.system);
  }

  /// Toggle between light and dark mode
  /// [isDark] - Verified visual state (e.g. from Theme.of(context).brightness)
  void toggleTheme({bool? isDark}) {
    if (state == ThemeMode.system && isDark != null) {
      // If system, flip based on verified brightness
      if (isDark) {
        setLightMode();
      } else {
        setDarkMode();
      }
    } else {
      // Standard toggle based on state
      if (state == ThemeMode.dark) {
        setLightMode();
      } else {
        setDarkMode();
      }
    }
  }

  /// Set theme mode directly
  void setThemeMode(ThemeMode mode) {
    state = mode;
    _saveTheme(mode);
  }

  /// Convert ThemeMode to String
  String _themeModeToString(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'light';
      case ThemeMode.dark:
        return 'dark';
      case ThemeMode.system:
        return 'system';
    }
  }

  /// Convert String to ThemeMode
  ThemeMode _themeModeFromString(String value) {
    switch (value) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }
}

/// Provider for SharedPreferences
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('SharedPreferences not initialized');
});

/// Provider for theme mode
final themeModeProvider = StateNotifierProvider<ThemeModeNotifier, ThemeMode>(
  (ref) => ThemeModeNotifier(ref.watch(sharedPreferencesProvider)),
);
