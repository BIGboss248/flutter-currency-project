import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:ui';
import 'dart:developer' as developer;

/*

This value notifier holds the current theme mode of the app.
It is initialized based on the platform's brightness setting.

*/
ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(
  PlatformDispatcher.instance.platformBrightness == Brightness.dark
      ? ThemeMode.dark
      : ThemeMode.light,
);

const String _themeKey = "user_theme_mode";

/*

  This function will load the saved theme preference from
  SharedPreferences and set the themeNotifier accordingly.

*/
Future<void> loadSavedTheme() async {
  final prefs = await SharedPreferences.getInstance();
  String? stored = prefs.getString(_themeKey);

  if (stored != null) {
    switch (stored) {
      case "light":
        themeNotifier.value = ThemeMode.light;
        developer.log("Loaded saved theme: light", level: 100);
        break;
      case "dark":
        themeNotifier.value = ThemeMode.dark;
        developer.log("Loaded saved theme: dark", level: 100);
        break;
      case "system":
        themeNotifier.value = ThemeMode.system;
        developer.log("Loaded saved theme: system", level: 100);
        break;
    }
  }
}

/*

  This function saves the user's theme preference
  to SharedPreferences.

*/
Future<void> saveTheme(ThemeMode mode) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString(_themeKey, mode.name); // "light", "dark", "system"
  developer.log("Saved theme mode as ${mode.name}", level: 100);
}
