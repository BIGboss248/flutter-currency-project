import 'package:flutter/material.dart';
import 'package:budgee/widgets/main_drawer.dart';
import 'package:budgee/widgets/main_bot_navbar.dart';

class Transactions extends StatefulWidget {
  const Transactions({required this.pageIndex, super.key});

  final int pageIndex;

  @override
  State<Transactions> createState() => _TransactionsState();
}

class _TransactionsState extends State<Transactions> {
  final List<Widget> items = []; // MUST NOT be const

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Transactions"), centerTitle: true),
      bottomNavigationBar: MainNavBar(currentIndex: widget.pageIndex),
      endDrawer: MainDrawer(),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: items.length,
        itemBuilder: (context, index) => items[index],
      ),

      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          setState(() {
            items.add(
              Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.blueAccent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  "New transaction added",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            );
          });
        },
      ),
    );
  }
}
