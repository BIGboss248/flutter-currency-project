import 'package:budgee/pages/new_note_page.dart';
import 'package:flutter/material.dart';
import 'package:budgee/constants/routes.dart';
import 'package:budgee/constants/theme.dart';
import 'package:budgee/pages/login_page.dart';
import 'package:budgee/pages/regiteration_page.dart';
import 'package:budgee/pages/notes_page.dart';
import 'package:budgee/pages/home.dart';
import 'package:budgee/pages/verify_email_page.dart';
import 'package:budgee/services/auth/auth_service.dart';
import 'package:budgee/widgets/theme_change.dart';
import 'package:go_router/go_router.dart';
import 'dart:developer' as developer;

// GoRouter configuration
final _router = GoRouter(
  /* TODO Implement route protection */
  routes: [
    GoRoute(
      path: mainPageRoute,
      builder: (context, state) => HomePage(pageIndex: 0),
    ),
    GoRoute(
      path: transactionsPageRoute,
      builder: (context, state) => Notes(pageIndex: 1),
    ),
    GoRoute(
      path: loginPageRoute,
      builder: (context, state) => LoginPage(pageIndex: 2),
    ),
    GoRoute(
      path: registerPageRoute,
      builder: (context, state) => RegisterationPage(pageIndex: 3),
    ),
    GoRoute(
      path: verifyEmailPageRoute,
      builder: (context, state) {
        final email = state.uri.queryParameters['email'];
        return VerifyEmailPage(pageIndex: 4, email: email);
      },
    ),
    GoRoute(
      path: newNoteRoute,
      builder: (context, state) {
        final noteId = state.uri.queryParameters['noteId'];
        if (noteId == null) {
          return NewNote(pageIndex: 5);
        }
        return NewNote(pageIndex: 5, noteId: int.parse(noteId));
      },
    ),
  ],
);

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
