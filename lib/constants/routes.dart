import 'package:budgee/pages/home.dart';
import 'package:budgee/pages/login_page.dart';
import 'package:budgee/pages/new_note_page.dart';
import 'package:budgee/pages/notes_page.dart';
import 'package:budgee/pages/regiteration_page.dart';
import 'package:budgee/pages/verify_email_page.dart';
import 'package:budgee/services/auth/auth_service.dart';
import 'package:budgee/utils/app_logger.dart';
import 'package:go_router/go_router.dart';

const String mainPageRoute = '/';
const String notesPageRoute = '/user-notes';
const String loginPageRoute = '/login';
const String registerPageRoute = '/register';
const String verifyEmailPageRoute = '/verify-email';
const String newNoteRoute = '/new-note';

// GoRouter configuration
final router = GoRouter(
  initialLocation: notesPageRoute,
  routes: [
    GoRoute(
      path: mainPageRoute,
      builder: (context, state) {
        logger.i("Navigating to Home page");
        return HomePage(pageIndex: 0);
      },
    ),
    GoRoute(
      path: notesPageRoute,
      builder: (context, state) {
        logger.i("Navigating to Notes page");
        return Notes(pageIndex: 1);
      },
      redirect: (context, state) {
        final user = AuthService.firebase().currentUser;
        final isLoggedIn = user != null;

        // Redirect to login if not authenticated
        if (!isLoggedIn) {
          logger.i("Redirecting from notes page to login page");
          return '$loginPageRoute?fromSourcePage=${Uri.encodeComponent(state.uri.toString())}';
        }

        return null; // No redirection
      },
    ),
    GoRoute(
      path: loginPageRoute,
      builder: (context, state) {
        final fromSourcePage = state.uri.queryParameters['fromSourcePage'];
        if (fromSourcePage != null) {
          logger.i("Redirecting from login page to notes page");
          return LoginPage(pageIndex: 2, fromSourcePage: fromSourcePage);
        }

        return LoginPage(pageIndex: 2);
      },
    ),
    GoRoute(
      path: registerPageRoute,
      builder: (context, state) {
        logger.i("Navigating to Registeration page");
        return RegisterationPage(pageIndex: 3);
      },
    ),
    GoRoute(
      path: verifyEmailPageRoute,
      builder: (context, state) {
        final email = state.uri.queryParameters['email'];
        logger.i("Navigating to Verify Email page for email: $email");
        return VerifyEmailPage(pageIndex: 4, email: email);
      },
    ),
    GoRoute(
      path: newNoteRoute,
      builder: (context, state) {
        logger.i("Navigating to New Note page");
        final noteId = state.uri.queryParameters['noteId'];
        if (noteId == null) {
          return NewNote(pageIndex: 5);
        }
        return NewNote(pageIndex: 5, noteId: noteId);
      },
      redirect: (context, state) {
        final isLoggedIn = AuthService.firebase().currentUser != null;

        // Redirect to login if not authenticated
        if (!isLoggedIn) {
          logger.i(
            "Redirecting from new note page to login page user is note logged in",
          );
          return '$loginPageRoute?fromSourcePage=${Uri.encodeComponent(state.uri.toString())}';
        }

        return null; // No redirection
      },
    ),
  ],
);
