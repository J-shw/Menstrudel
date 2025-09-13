import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:watch_connectivity/watch_connectivity.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  
  Future<void> _handleContext(Map<String, dynamic> context) async {
    debugPrint('Processing context: $context');
    final int? timestamp = context['timestamp'];
    if (timestamp == null) return; 

    final prefs = await SharedPreferences.getInstance();
    final processedIds = prefs.getStringList(_processedTimestampsKey) ?? [];

    if (processedIds.contains(timestamp.toString())) {
      debugPrint('Ignoring already processed context: $timestamp');
      return;
    }

    if (context['log_period'] == true) {
      onPeriodLogRequested?.call();
    }

    processedIds.add(timestamp.toString());
    await prefs.setStringList(_processedTimestampsKey, processedIds);
  }

  Future<void> sendCircleData({
    required int circleMaxValue,
    required int circleCurrentValue,
  }) async {
    final data = <String, dynamic>{
      'circleMaxValue': circleMaxValue,
      'circleCurrentValue': circleCurrentValue,
      'context_type': 'circle_data', 
    };
    
    _watch.updateApplicationContext(data);
  }

  void dispose() {
    _subscription?.cancel();
  }
}