import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MainNavBar extends StatelessWidget {
  final int currentIndex; // highlight current page

  const MainNavBar({super.key, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (int index) {
        if (index == 0) {
          context.go('/'); // replace current page with home
        } else if (index == 1) {
          context.push('/transactions'); // go to transactions page
        } else if (index == 2) {
          context.push('/login'); // go to login page
        }
      },
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
        BottomNavigationBarItem(
          icon: Icon(Icons.account_balance_wallet),
          label: "Transactions",
        ),
        BottomNavigationBarItem(icon: Icon(Icons.login), label: "Login"),
      ],
      selectedItemColor: Colors.blue,
      unselectedItemColor: Colors.grey,
    );
  }
}
