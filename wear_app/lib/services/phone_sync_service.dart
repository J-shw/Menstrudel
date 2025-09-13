import 'dart:async';
import 'package:watch_connectivity/watch_connectivity.dart';
import 'package:flutter/foundation.dart';
import 'package:menstrudel/models/circle_data.dart';
import 'package:menstrudel/models/phone_sync/app_context.dart';

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
    final appContext = AppContext.fromJson(context);

    switch (appContext.type) {
      case ContextType.circleDataUpdate:
        debugPrint("Processing circleDataUpdate");
        
        final data = CircleData(
          currentValue: appContext.data['circleCurrentValue'] as int? ?? 0,
          maxValue: appContext.data['circleMaxValue'] as int? ?? 28,
        );
        _circleDataController.add(data);
        break;
      default:
        break;
    }
  }

  void dispose() {
    _circleDataController.close();
  }
}