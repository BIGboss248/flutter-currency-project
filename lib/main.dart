import 'package:flutter/material.dart';
import 'package:budgee/constants/routes.dart';
import 'package:budgee/constants/theme.dart';
import 'package:budgee/services/auth/auth_service.dart';
import 'package:budgee/widgets/theme_change.dart';
import 'dart:developer' as developer;


void main() async {
  developer.log("Initializing widgets...", level: 100);
  WidgetsFlutterBinding.ensureInitialized();
  developer.log("Initializing firebase...", level: 100);
  await AuthService.firebase().initialize();
  await loadSavedTheme(); // Load persisted theme FIRST
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: themeNotifier,
      builder: (context, themeMode, child) {
        return MaterialApp.router(
          title: "Budgee",
          debugShowCheckedModeBanner: false,
          routerConfig: router,
          theme: lightTheme(),
          darkTheme: darkTheme(),
          themeMode: themeMode,
          locale: const Locale("en", "US"),
        );
      },
    );
  }
}
