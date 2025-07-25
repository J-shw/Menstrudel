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
      theme: ThemeData(
        useMaterial3: true,
        primarySwatch: Colors.blue, 
      ),
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text('Circle with Text Example'),
        ),
        body: const Center(
          child: BasicProgressCircle(
            currentValue: 7, // Example: 7 days left
            maxValue: 30,  // Out of 30 days total
            circleSize: 220,
            strokeWidth: 20,
            progressColor: Color.fromARGB(255, 255, 118, 118),
            trackColor: Color.fromARGB(20, 255, 118, 118),
          ),
        ),
      ),
    );
  }
}
