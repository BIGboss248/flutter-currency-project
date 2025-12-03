import 'package:flutter/material.dart';
import 'package:flutter_application_2/constants/routes.dart';
import 'package:flutter_application_2/services/auth/auth_execptions.dart';
import 'package:flutter_application_2/services/auth/auth_service.dart';
import 'package:flutter_application_2/widgets/main_drawer.dart';
import 'dart:developer' as developer;

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
  Future<void>? userVerifiEmailFuture;

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
                setState(() {
                  userVerifiEmailFuture = AuthService.firebase().createUser(
                    email: _emailController.text,
                    password: _passwordController.text,
                  );
                });
              },
              child: Text("Register"),
            ),
            FutureBuilder(
              future: userVerifiEmailFuture,
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                    return SizedBox.shrink();
                  case ConnectionState.active:
                  case ConnectionState.waiting:
                    return CircularProgressIndicator();
                  case ConnectionState.done:
                    String message;
                    if (snapshot.hasError) {
                      developer.log(snapshot.error.toString());
                      switch (snapshot.error) {
                        case EmailAlreadyInUseAuthExecption():
                          {
                            message = "Email already in use";
                          }
                        case InvalidEmailAuthExecption():
                          {
                            message = "Invalid Email";
                          }
                        case WrongPasswordAuthExecption():
                          {
                            message = "Wrong username or password";
                          }
                        case WeakPasswordAuthExecption():
                          {
                            message = "Password is too weak";
                          }
                        case GenericAuthExecption():
                          {
                            message = "Unknown error occured";
                          }
                        default:
                          {
                            message = "Error occured";
                          }
                      }
                      return Text(message, style: TextStyle(color: Colors.red));
                    }
                    developer.log(
                      "User registered: ${_emailController.text}",
                      level: 200,
                    );
                    developer.log(
                      "Sending user ${_emailController.text} to verification page",
                      level: 200,
                    );
                    developer.log(
                      "Routing to $verifyEmailPageRoute?email=${_emailController.text}",
                      level: 200,
                    );
                    context.push(
                      "$verifyEmailPageRoute?email=${_emailController.text}",
                    );
                    return Text(
                      "Verification Email sent please verify your email",
                      style: TextStyle(color: Colors.green),
                      textAlign: TextAlign.center,
                    );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
