/*

  Create our user object

*/
import 'package:firebase_auth/firebase_auth.dart' show User;
import 'package:flutter/foundation.dart'; // For class tags

@immutable
class AuthUser {
  final bool isEmailVerified;
  final String? email;
  String? get getEmail => email;
  const AuthUser(this.isEmailVerified, this.email);
  factory AuthUser.fromFireBase(User user) =>
      AuthUser(user.emailVerified, user.email);
}
