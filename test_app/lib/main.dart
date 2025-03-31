import 'package:flutter/material.dart';

void main() {
  // Flutter has a global called runApp, which
  // takes a widget and inflates to fit the screen.
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Habit Tracker')),
        body: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: const [
            AppIcon(icon: Icons.favorite, text: 'Favorites', color: Colors.red),
            AppIcon(icon: Icons.abc_outlined, text: 'Keyboard'),
            AppIcon(icon: Icons.access_alarm_outlined, text: 'Timers'),
          ],
        ),
      ),
    );
  }
}

class AppIcon extends StatelessWidget {
  const AppIcon({
    super.key,
    required this.icon,
    required this.text,
    this.color,
  });

  final IconData icon;
  final String text;
  final double iconSize = 40.0;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [Icon(icon, size: iconSize, color: color), Text(text)],
    );
  }
}
