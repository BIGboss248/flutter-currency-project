import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/constants/routes.dart';
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
                try {
                  final userCredential = await FirebaseAuth.instance
                      .createUserWithEmailAndPassword(
                        email: _emailController.text,
                        password: _passwordController.text,
                      );
                  developer.log(
                    "User registered: ${userCredential.user?.email}",
                    level: 200,
                  );
                  developer.log(
                    "Sending user ${userCredential.user?.email} to verification page",
                    level: 200,
                  );
                  developer.log(
                    "Routing to $verifyEmailPageRoute?email=${_emailController.text}",
                    level: 200,
                  );
                  context.push(
                    "$verifyEmailPageRoute?email=${_emailController.text}",
                  );
                } on FirebaseAuthException catch (e) {
                  // if (!mounted) return; //* GPT said i should add this to get rid of context warning IDK what it dose so i comment it out
                  switch (e.code) {
                    case "email-already-in-use":
                      developer.log(
                        "Email already in use ${_emailController.text}",
                        level: 600,
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Email already in use")),
                      );
                    case "weak-password":
                      developer.log(
                        "Password is too weak for user ${_emailController.text}",
                        level: 600,
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Password is too weak")),
                      );
                    case "invalid-email":
                      developer.log("Firebase Email is not valid", level: 600);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Email is not valid")),
                      );
                    default:
                      developer.log(
                        "Error registering in user: $e",
                        level: 600,
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Unknown register error occured"),
                        ),
                      );
                  }
                } catch (e) {
                  developer.log("Error registering user: $e", level: 600);
                }
              },
              child: Text("Register"),
            ),
            FutureBuilder(
              future: userVerifiEmailFuture,
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return CircularProgressIndicator();
                  case ConnectionState.done:
                    return Text(
                      "Verification Email sent please verify your email",
                      style: TextStyle(color: Colors.green),
                      textAlign: TextAlign.center,
                    );
                  default:
                    return SizedBox.shrink();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
