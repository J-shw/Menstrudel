import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wear_plus/wear_plus.dart';
import 'dart:async';
import 'package:watch_connectivity/watch_connectivity.dart';
import 'package:menstrudel/models/phone_sync/circle_data.dart';
import 'package:menstrudel/services/phone_sync_service.dart';
import 'package:menstrudel/widgets/progress_circle.dart';
import 'package:menstrudel/models/phone_sync/shared_context.dart';
import 'package:menstrudel/models/phone_sync/log_request.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
    final context = SharedContextData(
      circleData: _circleData,
      
      logRequest: LogRequest(timestamp: DateTime.now().millisecondsSinceEpoch),
    );

    _watch.updateApplicationContext(context.toJson());
    debugPrint('Sent log request with context: ${context.toJson()}');
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
    _dataService.dispose();
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