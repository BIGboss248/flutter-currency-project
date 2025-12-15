import 'package:budgee/pages/home.dart';
import 'package:budgee/pages/login_page.dart';
import 'package:budgee/pages/new_note_page.dart';
import 'package:budgee/pages/notes_page.dart';
import 'package:budgee/pages/regiteration_page.dart';
import 'package:budgee/pages/verify_email_page.dart';
import 'package:budgee/services/auth/auth_service.dart';
import 'package:go_router/go_router.dart';

const String mainPageRoute = '/';
const String transactionsPageRoute = '/transactions';
const String loginPageRoute = '/login';
const String registerPageRoute = '/register';
const String verifyEmailPageRoute = '/verify-email';
const String newNoteRoute = '/new-note';

// GoRouter configuration
final router = GoRouter(
  routes: [
    GoRoute(
      path: mainPageRoute,
      builder: (context, state) => HomePage(pageIndex: 0),
    ),
    GoRoute(
      path: transactionsPageRoute,
      builder: (context, state) => Notes(pageIndex: 1),
      redirect: (context, state) {
        final user = AuthService.firebase().currentUser;
        final isLoggedIn = user != null;

        // Redirect to login if not authenticated
        if (!isLoggedIn) {
          return loginPageRoute;
        }

        return null; // No redirection
      },
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
      redirect: (context, state) {
        final isLoggedIn = AuthService.firebase().currentUser != null;

        // Redirect to login if not authenticated
        if (!isLoggedIn) {
          return loginPageRoute;
        }

        return null; // No redirection
      },
    ),
  ],
);
