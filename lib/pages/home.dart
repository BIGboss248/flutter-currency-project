import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
        centerTitle: true,
        automaticallyImplyLeading: true,
      ),
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
      ),
      endDrawer: Drawer(
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Go to', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                ListTile(
                  title: const Center(child: Text('Home')),
                  onTap: () {
                    context.go('/');
                  },
                ),
                ListTile(
                  title: const Center(child: Text('Contact')),
                  onTap: () {
                    context.go("/contacts");
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      body: Column(),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          print("button pressed");
        },
      ),
    );
  }
}
