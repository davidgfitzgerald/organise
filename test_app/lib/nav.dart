import 'package:flutter/material.dart';
import 'package:test_app/main.dart';

class BottomNav extends StatelessWidget {
  const BottomNav({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isHomePage =
        context.widget is HomePage ||
        context.findAncestorWidgetOfExactType<HomePage>() != null;
    final bool isSettingsPage =
        context.widget is SettingsPage ||
        context.findAncestorWidgetOfExactType<SettingsPage>() != null;

    return BottomNavigationBar(
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
      ],
      onTap: (index) {
        // Check if trying to navigate to the current page
        if ((index == 0 && isHomePage) || (index == 1 && isSettingsPage)) {
          // Already on this page, do nothing
          return;
        }

        if (index == 0) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const HomePage()),
          );
        } else if (index == 1) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SettingsPage()),
          );
        }
      },
    );
  }
}
