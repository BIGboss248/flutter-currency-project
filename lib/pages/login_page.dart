import 'package:flutter/material.dart';
import 'package:flutter_application_2/widgets/main_bot_navbar.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({required this.pageIndex, super.key});

  final int pageIndex;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  //tip This is where to declare your variables and controllers and get data from internet. if needed use !initstate snippet to create init state

  late final TextEditingController _emailController;

  late final TextEditingController _passwordController;

  @override
  void initState() {
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    super.initState();
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
              onEditingComplete: () {
                //When the user presses enter (or done)
                setState(() {});
              },
            ),
            TextField(
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
          ],
        ),
      ),
    );
  }
}
