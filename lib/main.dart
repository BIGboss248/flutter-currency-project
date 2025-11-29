import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/constants/routes.dart';
import 'package:flutter_application_2/constants/theme.dart';
import 'package:flutter_application_2/pages/login_page.dart';
import 'package:flutter_application_2/pages/transactions.dart';
import 'package:flutter_application_2/pages/home.dart';
import 'package:flutter_application_2/widgets/theme_change.dart';
import 'package:go_router/go_router.dart';
import 'firebase_options.dart';
import 'dart:developer' as developer;

// GoRouter configuration
final _router = GoRouter(
  routes: [
    GoRoute(
      path: mainPageRoute,
      builder: (context, state) => HomePage(pageIndex: 0),
    ),
    GoRoute(
      path: transactionsPageRoute,
      builder: (context, state) => Transactions(pageIndex: 1),
    ),
    GoRoute(
      path: loginPageRoute,
      builder: (context, state) => LoginPage(pageIndex: 2),
    ),
  ],
);

void main() async {
  developer.log("Initializing widgets...", level: 100);
  WidgetsFlutterBinding.ensureInitialized();
  developer.log("Initializing firebase...", level: 100);
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
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
          routerConfig: _router,
          theme: lightTheme(),
          darkTheme: darkTheme(),
          themeMode: themeMode,
          locale: const Locale("en", "US"),
        );
      },
    );
  }
}
