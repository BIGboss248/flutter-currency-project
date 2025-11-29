import 'package:flutter/material.dart';

final brightThemeSeedColor = Colors.blue;
final darkThemeSeedColor = Colors.blue;

ThemeData lightTheme() {
  return ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: brightThemeSeedColor,
      brightness: Brightness.light,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all<Color>(brightThemeSeedColor),
        alignment: AlignmentGeometry.center,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        foregroundColor: WidgetStateProperty.all<Color>(brightThemeSeedColor),
        alignment: AlignmentGeometry.center,
      ),
    ),
    cardTheme: CardThemeData(color: brightThemeSeedColor),
  );
}

ThemeData darkTheme() {
  return ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: darkThemeSeedColor,
      brightness: Brightness.dark,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all<Color>(darkThemeSeedColor),
        alignment: AlignmentGeometry.center,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        foregroundColor: WidgetStateProperty.all<Color>(darkThemeSeedColor),
        alignment: AlignmentGeometry.center,
      ),
    ),
    cardTheme: CardThemeData(color: darkThemeSeedColor),
  );
}
