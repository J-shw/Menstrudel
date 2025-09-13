import 'dart:async';
import 'package:watch_connectivity/watch_connectivity.dart';
import 'package:flutter/foundation.dart';
import 'package:menstrudel/models/circle_data.dart';

class WatchDataService {
  final _watch = WatchConnectivity();
  final _circleDataController = StreamController<CircleData>.broadcast();
  Stream<CircleData> get circleDataStream => _circleDataController.stream;

  WatchDataService() {
    _watch.contextStream.listen(_handleContext);

    _checkInitialContext();
  }

  Future<void> _checkInitialContext() async {
    final initialContext = await _watch.applicationContext;
    if (initialContext.isNotEmpty) {
      _handleContext(initialContext);
    }
  }

  void _handleContext(Map<String, dynamic> context) {
    debugPrint("Received context $context");
    if (context.containsKey('circleMaxValue') && context.containsKey('circleCurrentValue')) {
      final data = CircleData(
        currentValue: context['circleCurrentValue'] as int,
        maxValue: context['circleMaxValue'] as int,
      );
      _circleDataController.add(data);
    }
  }

  void dispose() {
    _circleDataController.close();
  }
}