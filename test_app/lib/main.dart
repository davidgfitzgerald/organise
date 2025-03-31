import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:test_app/nav.dart';
import 'package:test_app/drawer.dart';
import 'package:test_app/scrollable.dart';

void main() {
  // Flutter has a global called runApp, which
  // takes a widget and inflates to fit the screen.
  runApp(const MyApp());
}

class MouseAndTouchScroll extends MaterialScrollBehavior {
  // Override behavior methods and getters like dragDevices
  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse, // allows scrolling with mouse on web
  };
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scrollBehavior: MouseAndTouchScroll(),
      home: SelectionArea(
        child: Scaffold(
          appBar: AppBar(title: const Text('Habit Tracker')),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              debugPrint('Pressed');
            },
            child: const Icon(Icons.add),
          ),
          bottomNavigationBar: BottomNav(),
          drawer: const SideDrawer(),
          body: const InfiniteScroll(),
        ),
      ),
    );
  }
}

class VerifiedIcon extends StatelessWidget {
  const VerifiedIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(color: Colors.blue, width: 40, height: 40),
        const Icon(Icons.verified, color: Colors.white, size: 32),
      ],
    );
  }
}

class IconButtons extends StatelessWidget {
  const IconButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: const [
            Expanded(
              flex: 4,
              child: AppIcon(
                icon: Icons.favorite,
                text: 'Favorites',
                color: Colors.red,
              ),
            ),
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
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [Icon(icon, size: iconSize, color: color), Text(text)],
      ),
    );
  }
}
