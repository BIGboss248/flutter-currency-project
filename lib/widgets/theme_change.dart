import 'package:budgee/utils/app_logger.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:ui';

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
        logger.i("Loaded saved theme: light");
        break;
      case "dark":
        themeNotifier.value = ThemeMode.dark;
        logger.i("Loaded saved theme: dark");
        break;
      case "system":
        themeNotifier.value = ThemeMode.system;
        logger.i("Loaded saved theme: system");
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
  logger.i("Saved theme mode as ${mode.name}");
}

class ThemeChangeIcon extends StatelessWidget {
  const ThemeChangeIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        if (themeNotifier.value == ThemeMode.dark) {
          saveTheme(ThemeMode.light);
          themeNotifier.value = ThemeMode.light;
        } else {
          saveTheme(ThemeMode.dark);
          themeNotifier.value = ThemeMode.dark;
        }
      },
      icon: ValueListenableBuilder(
        valueListenable: themeNotifier,
        builder: (context, themeMode, _) {
          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (child, animation) {
              return RotationTransition(
                turns: animation,
                child: FadeTransition(opacity: animation, child: child),
              );
            },
            child: Icon(
              themeMode == ThemeMode.dark ? Icons.light_mode : Icons.dark_mode,
              key: ValueKey(themeMode), // IMPORTANT
            ),
          );
        },
      ),
    );
  }
}
