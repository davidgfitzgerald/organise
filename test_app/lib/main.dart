import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:test_app/nav.dart';
import 'package:test_app/drawer.dart';
import 'package:test_app/scrollable.dart';

void main() {
  // Flutter has a global called runApp, which
  // takes a widget and inflates to fit the screen.
  runApp(const HomePage());

  // Flutter has navigator 1.0 and 2.0
  // 1.0 - Imperative & simple
  // 2.0 - Declarative & complex
}

class MouseAndTouchScroll extends MaterialScrollBehavior {
  // Override behavior methods and getters like dragDevices
  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse, // allows scrolling with mouse on web
  };
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

// Other state management options include
// - Riverpod
// - Provider
// - Bloc
// - Cubit
class _HomePageState extends State<HomePage> {
  int count = 0;

  @override
  void initState() {
    // TODO: fetch data from Firebase
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scrollBehavior: MouseAndTouchScroll(),
      home: SelectionArea(
        child: Scaffold(
          appBar: AppBar(title: const Text('Habit Tracker')),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              setState(() {
                count++;
              });
              debugPrint('Pressed');
            },
            child: const Icon(Icons.add),
          ),
          bottomNavigationBar: BottomNav(),
          drawer: const SideDrawer(),
          body: Stack(
            children: [
              const InfiniteScroll(),
              Center(
                child: Text(
                  'Count: $count',
                  style: const TextStyle(color: Colors.white, fontSize: 48),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
