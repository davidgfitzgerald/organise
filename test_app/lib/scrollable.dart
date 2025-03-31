import 'package:flutter/material.dart';

class ScrollableView extends StatelessWidget {
  const ScrollableView({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 3,
        child: Row(
          children: [
            Expanded(
              child: Container(
                height: MediaQuery.of(context).size.height,
                color: Colors.blue,
              ),
            ),
            Expanded(
              child: Container(
                height: MediaQuery.of(context).size.height,
                color: Colors.red,
              ),
            ),
            Expanded(
              child: Container(
                height: MediaQuery.of(context).size.height,
                color: Colors.green,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class InfiniteScroll extends StatelessWidget {
  const InfiniteScroll({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: ListView.builder(
        itemCount: 1000000, // not technically infinite, but close enough
        itemBuilder: (context, index) {
          return Container(height: 300, color: randomColour(index));
        },
      ),
    );
  }

  MaterialColor randomColour(int index) =>
      Colors.primaries[index % Colors.primaries.length];
}
