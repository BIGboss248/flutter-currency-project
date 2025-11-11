import 'package:flutter/material.dart';
import 'package:flutter_application_2/pages/transactions.dart';
import 'package:flutter_application_2/pages/home.dart';
import 'package:go_router/go_router.dart';

// GoRouter configuration
final _router = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (context, state) => HomePage()),
    GoRoute(path: '/transactions', builder: (context, state) => Transactions()),
  ],
);

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  final brightThemeSeedColor = Colors.blue;
  final darkThemeSeedColor = Colors.blue;

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: "Budgee",
      debugShowCheckedModeBanner: false,
      routerConfig: _router,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: brightThemeSeedColor,
          brightness: Brightness.light,
        ),
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: darkThemeSeedColor,
          brightness: Brightness.dark,
        ),
      ),
      themeMode: ThemeMode.system,
      locale: const Locale("en", "US"),
    );
  }
}
