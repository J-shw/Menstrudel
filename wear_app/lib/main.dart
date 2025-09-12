import 'package:flutter/material.dart';
import 'package:wear_plus/wear_plus.dart';
import 'dart:async';
import 'services/wear_sync_service.dart';

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
  final _wearSyncService = WearSyncService();
  WearPredictionData _predictionData = WearPredictionData(daysUntilDue: -1);
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _loadData();
    // Periodically check for new data from the phone app
    _timer = Timer.periodic(const Duration(seconds: 10), (timer) => _loadData());
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  /// Reads the latest prediction data using the sync service.
  Future<void> _loadData() async {
    final data = await _wearSyncService.readPrediction();
    if (mounted) {
      setState(() {
        _predictionData = data;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WatchShape(
      builder: (context, shape, child) {
        final daysUntilDue = _predictionData.daysUntilDue;
        String displayText;

        if (daysUntilDue == -1) {
          // Display '--' if no data is available yet
          displayText = '--';
        } else {
          // Display the number of days (or its absolute value if overdue)
          displayText = daysUntilDue.abs().toString();
        }

        return Center(
          child: Text(
            displayText,
            // Use a large, bold font style to make the number prominent
            style: Theme.of(context).textTheme.displayLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      },
    );
  }
}