import 'package:budgee/services/auth/auth_provider.dart';
import 'package:budgee/services/auth/bloc/auth_event.dart';
import 'package:budgee/services/auth/bloc/auth_state.dart';
import 'package:budgee/utils/app_logger.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(AuthProvider provider) : super(const AuthStateLoading()) {
    // Initialize
    on<AuthEventInitialize>((event, emit) async {
      await provider.initialize();
      final user = provider.currentUser;
      if (user == null) {
        emit(const AuthStateLoggedOut());
      } else if (!user.isEmailVerified) {
        emit(const AuthStateNeedsVerification());
      } else {
        emit(AuthStateLoggedIn(user));
      }
    });
    // Login
    on<AuthEventLogin>((event, emit) async {
      emit(AuthStateLoading());
      final email = event.email;
      final password = event.password;
      try {
        final user = await provider.logIn(email: email, password: password);
        emit(AuthStateLoggedIn(user));
      } on Exception catch (e) {
        emit(AuthStateLoginFalilure(e));
      }
    });
    //log out
    on<AuthEventLogout>((event, emit) async {
      emit(AuthStateLoading());
      try {
        await provider.logOut();
        emit(const AuthStateLoggedOut());
      } on Exception {
        emit(AuthStateLogOutFailure());
      }
    });
    // Register
    //TODO handle registration exceptions
    on<AuthEventRegister>((event, emit) async {
      final email = event.email;
      final password = event.password;
      try {
        await provider.createUser(email: email, password: password);
        emit(AuthStateRegisterationSuccess());
      } on Exception catch (e) {
        logger.e("Registration failed for email $email: $e");
        emit(AuthStateRegisterationFailure(e));
      }
    });
  }
}
