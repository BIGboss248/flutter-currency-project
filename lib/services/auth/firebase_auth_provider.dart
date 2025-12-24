/*
  In this file we create firebase authProvide for our authService to use
*/
import 'package:budgee/utils/app_logger.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:budgee/firebase_options.dart';
import 'package:budgee/services/auth/auth_provider.dart';
import 'package:budgee/services/auth/auth_execptions.dart';
import 'package:budgee/services/auth/auth_user.dart';
import 'package:firebase_auth/firebase_auth.dart'
    show FirebaseAuth, FirebaseAuthException;

class FireBaseAuthProvider implements AuthProvider {
  @override
  Future<AuthUser> createUser({
    required String email,
    required String password,
  }) async {
    try {
      logger.i("Creating user with email: $email");
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = currentUser;
      if (user != null) {
        return user;
      } else {
        logger.e("Failed to create a user $email");
        throw UserNotLoggedInAuthException();
      }
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "email-already-in-use":
          logger.e("Email $email already in use");
          throw EmailAlreadyInUseAuthExecption();
        case "weak-password":
          logger.e("User $email failed to subscription with weak password");
          throw WeakPasswordAuthExecption();
        case "invalid-email":
          logger.e("User failed to sign up with invalid email$email");
          throw InvalidEmailAuthExecption();
        default:
          logger.e("Generic error occurred while creating user $email");
          throw GenericAuthExecption();
      }
    } catch (e) {
      throw GenericAuthExecption();
    }
  }

  @override
  Future<AuthUser> logIn({
    required String email,
    required String password,
  }) async {
    try {
      logger.i("Logging in user with email: $email");
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = currentUser;
      if (user != null) {
        return user;
      } else {
        logger.e("Failed to log in user $email");
        throw UserNotLoggedInAuthException();
      }
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "wrong-password":
          logger.e("User $email failed to login with wrong password");
          throw WrongPasswordAuthExecption();
        case "user-not-found":
          logger.e("User with email $email not found");
          throw UserNotFoundAuthExecption();
        case "invalid-email":
          logger.e("User failed to login with invalid email $email");
          throw InvalidEmailAuthExecption();
        default:
          throw GenericAuthExecption();
      }
    } catch (e) {
      throw GenericAuthExecption();
    }
  }

  @override
  Future<void> logOut() async {
    logger.i("Logging out user");
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseAuth.instance.signOut();
    } else {
      logger.e("Failed to log out user because no user is logged in");
      throw UserNotLoggedInAuthException();
    }
  }

  @override
  Future<void> sendEmailVerification() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      logger.i("Sending email verification to user ${user.email}");
      user.sendEmailVerification();
    } else {
      logger.e(
        "Failed to send email verification because no user is logged in",
      );
      throw UserNotLoggedInAuthException();
    }
  }

  @override
  AuthUser? get currentUser {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return AuthUser.fromFireBase(user);
    }
    return null;
  }

  @override
  Future<void> initialize() async {
    logger.i("Initializing firebase auth provider...");
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }
}
