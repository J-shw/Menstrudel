import 'package:flutter/material.dart';
import 'package:wear_plus/wear_plus.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // A dark theme is better for OLED watch screens
    return MaterialApp(
      theme: ThemeData.dark(),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Use WatchShape to build a UI that is aware of the screen shape
    return WatchShape(
      builder: (context, shape, child) {
        // A GestureDetector makes a larger area of the screen tappable
        return GestureDetector(
          onTap: _incrementCounter,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text(
                  'Taps:',
                ),
                Text(
                  '$_counter',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                // Display the detected screen shape
                SizedBox(height: 8),
                Text(
                  'Shape: ${shape == WearShape.round ? 'Round' : 'Square'}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}