import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as developer;

class VerifyEmailPage extends StatefulWidget {
  const VerifyEmailPage({super.key, required this.pageIndex, this.email});

  final int pageIndex;
  final String? email;

  @override
  State<VerifyEmailPage> createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  final submitFocusNode = FocusNode();
  final _emailController = TextEditingController();
  final emailFocusNode = FocusNode();
  String message =
      "Enter your email and press the button to verify your email address";
  Future<void>? emailVerificationFuture;

  @override
  void initState() {
    developer.log("Inside verification page email recived is ${widget.email}");
    super.initState();
    if (widget.email != null) {
      _emailController.text = widget.email!;
      message =
          "Your registeration is almost complete please verify your email address";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Verify Email"),
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
            Text(message, textAlign: TextAlign.center),
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
                labelText:
                    "Registeration Email", // Label text when the field is focused
                hintText:
                    "Enter the Email you registered with", // Hint text when the field is empty
                border: OutlineInputBorder(), // Border around the text field
              ),
              onSubmitted: (_) {
                FocusScope.of(context).requestFocus(submitFocusNode);
              },
            ),
            ElevatedButton(
              onPressed: () {
                final user = FirebaseAuth.instance.currentUser;
                setState(() {
                  emailVerificationFuture = user?.sendEmailVerification();
                });
              },
              focusNode: submitFocusNode,
              child: Text("Verify Email"),
            ),
            FutureBuilder(
              future: emailVerificationFuture,
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
