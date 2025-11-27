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
        switch (index) {
          case 0:
            {
              context.go("/");
              break;
            }
          case 1:
            {
              context.push("/transactions");
              break;
            }
          case 2:
            {
              context.push("/login");
              break;
            }
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
