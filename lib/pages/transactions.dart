import 'package:flutter/material.dart';
import 'package:flutter_application_2/widgets/theme_change.dart';
import 'package:flutter_application_2/widgets/main_bot_navbar.dart';

class Transactions extends StatefulWidget {
  const Transactions({super.key});

  @override
  State<Transactions> createState() => _TransactionsState();
}

class _TransactionsState extends State<Transactions> {
  int currentPage = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          // ThemeChangeIcon allows the user to toggle between light and dark themes.
          ThemeChangeIcon(),
        ],
      ),
      bottomNavigationBar: MainNavBar(currentIndex: 1),
      body: Column(),
    );
  }
}

