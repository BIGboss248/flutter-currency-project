import 'package:flutter/material.dart';
import 'package:budgee/widgets/theme_change.dart';

class MainDrawer extends StatefulWidget {
  const MainDrawer({super.key});

  @override
  State<MainDrawer> createState() => _MainDrawerState();
}

class _MainDrawerState extends State<MainDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 10.0,
        children: [Text("Drawer"), ThemeChangeIcon()],
      ),
    );
  }
}
