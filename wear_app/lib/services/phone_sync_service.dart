import 'dart:async';
import 'package:watch_connectivity/watch_connectivity.dart';
import 'package:flutter/foundation.dart';
import 'package:menstrudel/models/phone_sync/circle_data.dart';
import 'package:menstrudel/models/phone_sync/shared_context.dart';

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

  void _handleContext(Map<dynamic, dynamic> contextMap) {
    final context = SharedContextData.fromJson(contextMap);
    debugPrint('Received context: ${context.toString()}');

    if (context.circleData != null) {
      debugPrint("Processing circleData update");
      
      _circleDataController.add(context.circleData!);
    }
  }

  void dispose() {
    _circleDataController.close();
  }
}