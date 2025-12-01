/*
  In this file we create firebase authProvide for our authService to use
*/
import 'package:flutter_application_2/services/auth/auth_provider.dart';
import 'package:flutter_application_2/services/auth/auth_execptions.dart';
import 'package:flutter_application_2/services/auth/auth_user.dart';
import 'package:firebase_auth/firebase_auth.dart'
    show FirebaseAuth, FirebaseAuthException;

class FireBaseAuthProvide implements AuthProvider {
  @override
  Future<AuthUser> createUser({
    required String email,
    required String password,
  }) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = currentUser;
      if (user != null) {
        return user;
      } else {
        throw UserNotLoggedInAuthException();
      }
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "email-already-in-use":
          throw EmailAlreadyInUseAuthExecption();
        case "weak-password":
          throw WeakPasswordAuthExecption();
        case "invalid-email":
          throw InvalidEmailAuthExecption();
        default:
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
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = currentUser;
      if (user != null) {
        return user;
      } else {
        throw UserNotLoggedInAuthException();
      }
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "wrong-password":
          throw WrongPasswordAuthExecption();
        case "user-not-found":
          throw UserNotFoundAuthExecption();
        case "invalid-email":
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
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseAuth.instance.signOut();
    } else {
      throw UserNotLoggedInAuthException();
    }
  }

  @override
  Future<void> sendEmailVerification() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      user.sendEmailVerification();
    } else {
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
}
