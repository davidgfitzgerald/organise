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
        body: Container(
          margin: EdgeInsets.all(10),
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Text('Hi, Mom!', style: TextStyle(color: Colors.white)),
        ),
      ),
    );
  }
}
