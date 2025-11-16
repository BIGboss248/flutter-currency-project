import 'package:flutter/material.dart';
import 'package:flutter_application_2/widgets/widget_library.dart';

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
      appBar: AppBar(),
      bottomNavigationBar: MainNavBar(currentIndex: 1),
      body: Column(),
    );
  }
}
