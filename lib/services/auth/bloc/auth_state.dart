import 'package:budgee/services/auth/auth_user.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:equatable/equatable.dart';

@immutable
abstract class AuthState {
  const AuthState();
}

class AuthStateLoading extends AuthState {
  const AuthStateLoading();
}

class AuthStateLoggedIn extends AuthState {
  final AuthUser user;
  const AuthStateLoggedIn(this.user);
}

class AuthStateLoggedOut extends AuthState {
  const AuthStateLoggedOut();
}

class AuthStateLogOutFailure extends AuthState with EquatableMixin {
  final Exception? exception;
  final bool? emailVerification;

  const AuthStateLogOutFailure({this.exception, this.emailVerification});

  @override
  List<Object?> get props => [exception, emailVerification];
}

class AuthStateRegisterationSuccess extends AuthState {
  const AuthStateRegisterationSuccess();
}

class AuthStateRegisterationFailure extends AuthState {
  final Exception exception;
  const AuthStateRegisterationFailure(this.exception);
}
