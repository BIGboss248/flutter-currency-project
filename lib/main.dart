import 'package:budgee/services/auth/bloc/auth_bloc.dart';
import 'package:budgee/services/auth/firebase_auth_provider.dart';
import 'package:budgee/utils/app_logger.dart';
import 'package:flutter/material.dart';
import 'package:budgee/constants/routes.dart';
import 'package:budgee/constants/theme.dart';
import 'package:budgee/services/auth/auth_service.dart';
import 'package:budgee/widgets/theme_change.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  // logger.i("Initializing widgets...");
  WidgetsFlutterBinding.ensureInitialized();
  await initializeLogger();
  logger.i("Initializing firebase...");
  await AuthService.firebase().initialize();
  /* TODO Setup theme change and light mode change */
  await loadSavedTheme(); // Load persisted theme FIRST
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthBloc(FireBaseAuthProvider()),
      child: ValueListenableBuilder(
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
      ),
    );
  }
}
