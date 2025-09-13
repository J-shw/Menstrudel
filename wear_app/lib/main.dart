import 'package:flutter/material.dart';
import 'package:wear_plus/wear_plus.dart';
import 'dart:async';
import 'package:watch_connectivity/watch_connectivity.dart';
import 'package:menstrudel/widgets/progress_circle.dart';
import 'package:flutter/services.dart';
import 'package:menstrudel/models/circle_data.dart';
import 'package:menstrudel/services/phone_sync_service.dart';

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
  final _dataService = WatchDataService();
  StreamSubscription? _dataSubscription;
  CircleData _circleData = CircleData();

  @override
  void initState() {
    super.initState();
    _dataSubscription = _dataService.circleDataStream.listen((newData) {
      if (mounted) {
        setState(() {
          _circleData = newData;
        });
      }
    });
  }

  void _logPeriod() {
    debugPrint('Sent request to log period from the watch.');
    final data = {
      'log_period': true,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      'context_type': 'log_period', 
    };
    _watch.updateApplicationContext(data);
  }

  void _showConfirmationDialog() {
    HapticFeedback.mediumImpact();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Scaffold(
          backgroundColor: Colors.black.withValues(alpha: 0.7),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Log period for today?',
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: ElevatedButton.styleFrom(
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(12),
                        backgroundColor: Colors.redAccent,
                      ),
                      child: const Icon(Icons.close, color: Colors.white),
                    ),
                    const SizedBox(width: 20),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop(); 
                        _logPeriod();
                      },
                      style: ElevatedButton.styleFrom(
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(12),
                        backgroundColor: Colors.green,
                      ),
                      child: const Icon(Icons.check, color: Colors.white),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _dataSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WatchShape(
        builder: (context, shape, child) {
          return GestureDetector(
            onLongPress: _showConfirmationDialog,
            child: Center(
              child: WearProgressCircle(
                currentValue: _circleData.currentValue,
                maxValue: _circleData.maxValue,
                progressColor: const Color.fromARGB(255, 255, 118, 118),
                trackColor: const Color.fromARGB(20, 255, 118, 118),
              ),
            ),
          );
        },
      ),
    );
  }
}