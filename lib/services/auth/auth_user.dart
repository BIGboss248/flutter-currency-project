/*

  Create our user object

*/
import 'package:firebase_auth/firebase_auth.dart' show User;
import 'package:flutter/foundation.dart'; // For class tags

/* TODO Check class flags */
@immutable
class AuthUser {
  final String id;
  final bool isEmailVerified;
  final String email;
  get getEmail => email;
  const AuthUser({required this.isEmailVerified, required this.email, required this.id});
  factory AuthUser.fromFireBase(User user) =>
      AuthUser(isEmailVerified: user.emailVerified, email: user.email!, id: user.uid);
}
