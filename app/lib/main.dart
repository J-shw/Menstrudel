import 'package:flutter/material.dart';
import 'package:menstrudel/widgets/days_counter_circle.dart';

void main() {
  runApp(const MainApp());
}


class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text('Circle with Text Example'),
        ),
        body: const Center(
          child: DaysCounterCircle(
            days: 14,
            circleSize: 220,
            borderColor: Color.fromARGB(255, 255, 118, 118),
          ),
        ),
      ),
    );
  }
}
