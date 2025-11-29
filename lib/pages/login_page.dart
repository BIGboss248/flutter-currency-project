import 'package:flutter/material.dart';
import 'package:flutter_application_2/widgets/main_bot_navbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:developer' as developer;

class LoginPage extends StatefulWidget {
  const LoginPage({required this.pageIndex, super.key});

  final int pageIndex;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;

  Future<UserCredential>? signInFuture; // Initialize signInFuture to null
  Future<dynamic>? signOutFuture;

  final emailFocusNode = FocusNode();
  final passwordFocusNode = FocusNode();
  final registerFocusNode = FocusNode();

  @override
  void initState() {
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    registerFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
        centerTitle: true,
        automaticallyImplyLeading: true, // The back button to previous page
      ),
      bottomNavigationBar: MainNavBar(currentIndex: widget.pageIndex),
      body: Container(
        margin: const EdgeInsets.all(20),
        child: Column(
          spacing: 20.0,
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
            Center(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    focusNode: registerFocusNode,
                    onPressed: () async {
                      if (_emailController.text.isEmpty ||
                          _passwordController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              "Email and Password cannot be empty.",
                            ),
                          ),
                        );
                        return;
                      }
                      try {
                        final userCredential = await FirebaseAuth.instance
                            .createUserWithEmailAndPassword(
                              email: _emailController
                                  .text, // You can get this data from user using text fields
                              password: _passwordController
                                  .text, // You can get this data from user using text fields
                            );
                        developer.log(
                          "User registered: ${userCredential.user?.email}",
                          level: 200,
                        );
                      } catch (e) {
                        developer.log(
                          "Error registering user: $e",
                          level: 1000,
                        );
                      }
                    },
                    child: Text("Register"),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      if (_emailController.text.isEmpty ||
                          _passwordController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              "Email and Password cannot be empty.",
                            ),
                          ),
                        );
                        return;
                      }
                      try {
                        signInFuture = FirebaseAuth.instance
                            .signInWithEmailAndPassword(
                              email: _emailController.text,
                              password: _passwordController.text,
                            );
                        // The idea for below is to await data to be fetched before logging using developer.log so the data is not shown as null because of async nature
                        // ignore: unused_local_variable
                        final userCredential = await signInFuture;
                        developer.log(
                          "User logged in: ${FirebaseAuth.instance.currentUser?.email}",
                          level: 200,
                        );
                      } catch (e) {
                        developer.log("Error logging in user: $e", level: 1000);
                      }
                    },
                    child: Text("Login"),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      if (FirebaseAuth.instance.currentUser != null) {
                        final shouldLogOut = await showLogoutDialog(context);
                        if (shouldLogOut != true) {
                          developer.log("Logout cancelled by user", level: 200);
                          return;
                        }
                        signOutFuture = FirebaseAuth.instance.signOut();
                        developer.log("User logged out", level: 200);
                      } else {
                        developer.log(
                          "No user is currently logged in",
                          level: 800,
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              "You are not logged in",
                              textAlign: TextAlign.center,
                            ),
                          ),
                        );
                      }
                    },
                    child: Text("Log out"),
                  ),
                ],
              ),
            ),
            FutureBuilder(
              future: signInFuture,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (signInFuture == null) {
                  return const SizedBox.shrink(); // Placeholder when no future is set
                }
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                    return const CircularProgressIndicator();
                  case ConnectionState.active:
                  case ConnectionState.done:
                    if (snapshot.hasError) {
                      return Container(
                        color: Colors.amber,
                        child: Text(
                          "Error occured during login",
                          style: const TextStyle(color: Colors.red),
                        ),
                      );
                    } else {
                      return Container(
                        color: Theme.of(context).primaryColor,
                        child: const Text(
                          "Login Successful!",
                          style: TextStyle(color: Colors.green),
                        ),
                      );
                    }
                }
              },
            ),
            FutureBuilder(
              future: signOutFuture,
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return CircularProgressIndicator();
                  case ConnectionState.done:
                    return Text("Logged out successfully");
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

// Show an alert dialog with a choice can be configured to return any future type
Future<bool> showLogoutDialog(BuildContext context) async {
  final result = await showDialog<bool>(
    context: context,
    barrierDismissible: true,
    builder: (context) => AlertDialog(
      title: const Text('Confirm Logout', textAlign: TextAlign.center),
      content: const Text(
        'Are you sure you want to log out?',
        textAlign: TextAlign.center,
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Log out'),
            ),
          ],
        ),
      ],
    ),
  );
  return result ?? false;
}
