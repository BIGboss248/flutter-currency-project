import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Contacts extends StatefulWidget {
  const Contacts({super.key});

  @override
  State<Contacts> createState() => _ContactsState();
}

class _ContactsState extends State<Contacts> {
  int currentPage = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      bottomNavigationBar: NavigationBar(
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: "Home"),
          NavigationDestination(icon: Icon(Icons.phone), label: "Contact"),
        ],
        onDestinationSelected: (int index) {
          setState(() {
            currentPage = index;
          });
          if (index == 0) {
            context.go('/');
          } else if (index == 1) {
            context.go('/contacts');
          }
        },
      ), //tip use !navigation bar snippet to create navigation bar
      endDrawer: Drawer(),
      body: Column(),
    );
  }
}
