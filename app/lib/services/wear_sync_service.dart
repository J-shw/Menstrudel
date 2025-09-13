import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:watch_connectivity/watch_connectivity.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:menstrudel/models/watch_sync/shared_context.dart';
import 'package:menstrudel/models/watch_sync/circle_data.dart';

class WatchSyncService {
  final _watch = WatchConnectivity();
  StreamSubscription? _subscription;
  static const _processedTimestampsKey = 'processed_watch_timestamps';

  void Function()? onPeriodLogRequested;

  Future<void> initialize({required void Function() onPeriodLog}) async {
    onPeriodLogRequested = onPeriodLog;

    debugPrint('Initialising and listening on applicationContextStream...');


    final missedContexts = await _watch.receivedApplicationContexts;
    for (final context in missedContexts) {
      await _handleContext(context);
    }

    _subscription = _watch.contextStream.listen(_handleContext);
  }
  
  Future<void> _handleContext(Map<dynamic, dynamic> contextMap) async {
    final context = SharedContextData.fromJson(contextMap);

    if (context.logRequest == null) {
      return;
    }

    final timestamp = context.logRequest!.timestamp;
    final prefs = await SharedPreferences.getInstance();
    final processedIds = prefs.getStringList(_processedTimestampsKey) ?? [];

    if (processedIds.contains(timestamp.toString())) {
      debugPrint('Ignoring already processed log request: $timestamp');
      return;
    }

    debugPrint('Processing new log request: $timestamp');
    onPeriodLogRequested?.call();

    processedIds.add(timestamp.toString());
    await prefs.setStringList(_processedTimestampsKey, processedIds);
  }

  Future<void> sendCircleData({
    required int circleMaxValue,
    required int circleCurrentValue,
  }) async {
    final newCircleData = CircleData(
      currentValue: circleCurrentValue,
      maxValue: circleMaxValue,
    );
    
    final context = SharedContextData(circleData: newCircleData);

    debugPrint('Sending circle data: ${context.toString()}');
    
    _watch.updateApplicationContext(context.toJson());
  }

  void dispose() {
    _subscription?.cancel();
  }
}