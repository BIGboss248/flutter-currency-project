import 'package:flutter/material.dart';
import 'package:flutter_application_2/pages/contacts.dart';
import 'package:flutter_application_2/pages/home.dart';
import 'package:go_router/go_router.dart';

// GoRouter configuration
final _router = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (context, state) => HomePage()),
    GoRoute(path: '/contacts', builder: (context, state) => Contacts()),
  ],
);

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  final seedColor = const Color.fromARGB(255, 154, 100, 255);

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: "Budgee",
      debugShowCheckedModeBanner: false,
      routerConfig: _router,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: seedColor,
          brightness: Brightness.light,
        ),
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: seedColor,
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: ColorScheme.fromSeed(
          seedColor: seedColor,
        ).surface,
        appBarTheme: AppBarTheme(
          backgroundColor: ColorScheme.fromSeed(
            seedColor: seedColor,
            brightness: Brightness.dark,
          ).surface,
        ),
      ),
      themeMode: ThemeMode.system,
      locale: const Locale("en", "US"),
    );
  }
}
