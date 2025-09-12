import 'package:flutter/material.dart';
import 'package:wear_plus/wear_plus.dart';
import 'dart:async';
import 'package:watch_connectivity/watch_connectivity.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Menstrudel Wear',
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
  final _watch = WatchConnectivity();
  int _daysUntilDue = -1;
  StreamSubscription? _messageSubscription;

  @override
  void initState() {
    super.initState();
    _messageSubscription = _watch.messageStream.listen((message) {
      final days = message['daysUntilDue'] as int?;
      if (days != null && mounted) {
        setState(() {
          _daysUntilDue = days;
        });
      }
    });
  }

  @override
  void dispose() {
    _messageSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WatchShape(
      builder: (context, shape, child) {
        String displayText = (_daysUntilDue == -1) ? '--' : _daysUntilDue.abs().toString();

        return Center(
          child: Text(
            displayText,
            style: Theme.of(context).textTheme.displayLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      },
    );
  }
}