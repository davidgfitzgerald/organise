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
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: const Text(
            'Habit Tracker',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
