import 'package:budgee/services/auth/auth_execptions.dart';
import 'package:budgee/services/auth/bloc/auth_bloc.dart';
import 'package:budgee/services/auth/bloc/auth_event.dart';
import 'package:budgee/services/auth/bloc/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:budgee/constants/routes.dart';
import 'package:budgee/widgets/main_drawer.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:go_router/go_router.dart';

class RegisterationPage extends StatefulWidget {
  const RegisterationPage({super.key, required this.pageIndex});

  final int pageIndex;

  @override
  State<RegisterationPage> createState() => _RegisterationPageState();
}

class _RegisterationPageState extends State<RegisterationPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final registerFocusNode = FocusNode();
  final emailFocusNode = FocusNode();
  final passwordFocusNode = FocusNode();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    registerFocusNode.dispose();
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Register"),
        centerTitle: true,
        automaticallyImplyLeading: true,
      ),
      endDrawer: MainDrawer(),
      body: Container(
        padding: EdgeInsets.all(20.0),
        child: Column(
          spacing: 20.0,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextField(
              focusNode: emailFocusNode,
              controller:
                  _emailController, // Controller to get the text from the text //* this must be declared outside build method
              enableSuggestions:
                  true, // Enable suggestions for the text field disable for password fields
              autocorrect:
                  true, // Enable autocorrect for the text field disable for password fields
              obscureText:
                  false, // Obscure text for password fields set to true for password fields
              keyboardType: TextInputType
                  .emailAddress, // Shows a keyboard with @ and for email input
              decoration: InputDecoration(
                labelText: "Email", // Label text when the field is focused
                hintText:
                    "Enter your mail", // Hint text when the field is empty
                border: OutlineInputBorder(), // Border around the text field
              ),
              onSubmitted: (_) {
                FocusScope.of(context).requestFocus(passwordFocusNode);
              },
            ),
            TextField(
              focusNode: passwordFocusNode,
              controller: _passwordController,
              enableSuggestions: false,
              autocorrect: false,
              obscureText: true,
              keyboardType: TextInputType.visiblePassword,
              decoration: InputDecoration(
                labelText: "Password",
                hintText: "Enter your password",
                border: OutlineInputBorder(),
              ),
            ),
            ElevatedButton(
              focusNode: registerFocusNode,
              onPressed: () async {
                if (_emailController.text.isEmpty ||
                    _passwordController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Email and Password cannot be empty."),
                    ),
                  );
                  return;
                }
                context.read<AuthBloc>().add(
                  AuthEventRegister(
                    email: _emailController.text,
                    password: _passwordController.text,
                  ),
                );
              },
              child: Text("Register"),
            ),
            ElevatedButton(
              onPressed: () {
                context.push(verifyEmailPageRoute);
              },
              child: Text("Email verification"),
            ),
            BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                if (state is AuthStateRegisterationFailure) {
                  final exception = state.exception;
                  if (exception is WeakPasswordAuthExecption) {
                    return Text(
                      "Weak password",
                      style: TextStyle(color: Colors.red),
                    );
                  } else if (exception is InvalidEmailAuthExecption) {
                    return Text(
                      "Invalid email",
                      style: TextStyle(color: Colors.red),
                    );
                  } else if (exception is EmailAlreadyInUseAuthExecption) {
                    return Text(
                      "Email already in use",
                      style: TextStyle(color: Colors.red),
                    );
                  }
                  return Text(
                    "Registration failed",
                    style: TextStyle(color: Colors.red),
                  );
                } else if (state is AuthStateRegisterationSuccess) {
                  return Text(
                    "Registration successful, please verify your email",
                    style: TextStyle(color: Colors.green),
                  );
                } else if (state is AuthStateLoading) {
                  return CircularProgressIndicator();
                } else if (state is AuthStateLoggedIn) {
                  return Text(
                    "You are already logged in",
                    style: TextStyle(color: Colors.green),
                  );
                } else if (state is AuthStateLoggedOut) {
                  return Text("You are not logged in");
                } else if (state is AuthStateNeedsVerification) {
                  return Text(
                    "You are registered but you need to verify your email",
                    style: TextStyle(color: Colors.orange),
                  );
                }
                return Text("Well registeration didn't fail or succeed");
              },
            ),
          ],
        ),
      ),
    );
  }
}
