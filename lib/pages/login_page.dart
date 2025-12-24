import 'package:budgee/services/auth/bloc/auth_bloc.dart';
import 'package:budgee/services/auth/bloc/auth_event.dart';
import 'package:budgee/services/auth/bloc/auth_state.dart';
import 'package:budgee/utils/app_logger.dart';
import 'package:budgee/widgets/alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:budgee/constants/routes.dart';
import 'package:budgee/services/auth/auth_service.dart';
import 'package:budgee/widgets/main_bot_navbar.dart';
import 'package:budgee/widgets/main_drawer.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:go_router/go_router.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({required this.pageIndex, super.key, this.fromSourcePage});

  final int pageIndex;

  final String? fromSourcePage;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;

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
      endDrawer: MainDrawer(),
      bottomNavigationBar: MainNavBar(currentIndex: widget.pageIndex),
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center, // Center content vertically
          crossAxisAlignment:
              CrossAxisAlignment.center, // Center content horizontally
          spacing: 20.0,
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.1),
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
                      context.read<AuthBloc>().add(
                        AuthEventLogin(
                          email: _emailController.text,
                          password: _passwordController.text,
                        ),
                      );
                    },
                    child: Text("Login"),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      if (AuthService.firebase().currentUser != null) {
                        final shouldLogOut =
                            await showChoiceDialog<bool>(
                              context: context,
                              title: "Logout",
                              content: "Are you sure",
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context, false);
                                  },
                                  child: Text("Cancel"),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context, true);
                                  },
                                  child: Text("Yes"),
                                ),
                              ],
                            ) ??
                            false;
                        if (shouldLogOut == false) {
                          logger.i("Logout cancelled by user");
                          return;
                        } else {
                          context.read<AuthBloc>().add(AuthEventLogout());
                          return;
                        }
                      } else {
                        logger.e("No user is currently logged in");
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
            ElevatedButton(
              onPressed: () {
                context.push(registerPageRoute);
              },
              child: Text("Not a user? Register here!!"),
            ),
            BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                if (state is AuthStateLoggedOut) {
                  return Text(
                    "You are logged out",
                    style: TextStyle(color: Colors.red),
                  );
                } else if (state is AuthStateLoggedIn) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (widget.fromSourcePage != null &&
                        widget.fromSourcePage!.isNotEmpty) {
                      context.go(widget.fromSourcePage!);
                    }
                  });
                  return Text(
                    "Login Successful!",
                    style: TextStyle(color: Colors.green),
                  );
                } else if (state is AuthStateNeedsVerification) {
                  return Text(
                    "Please verify your email address to continue",
                    style: TextStyle(color: Colors.orange),
                  );
                }
                return Text("IDK");
              },
            ),
          ],
        ),
      ),
    );
  }
}
