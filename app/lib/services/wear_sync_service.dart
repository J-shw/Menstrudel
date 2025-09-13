import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:watch_connectivity/watch_connectivity.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:menstrudel/models/watch_sync/app_context.dart';

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
    final appContext = AppContext.fromJson(context);
    final prefs = await SharedPreferences.getInstance();
    final processedIds = prefs.getStringList(_processedTimestampsKey) ?? [];
    if (processedIds.contains(appContext.timestamp.toString())) {
      debugPrint('Ignoring already processed context: ${appContext.timestamp}');
      return;
    }

    switch (appContext.type) {
      case ContextType.logPeriodRequest:
        debugPrint('Processing logPeriodRequest: ${appContext.timestamp}');
        onPeriodLogRequested?.call();
        break;
      default:
        break;
    }
    processedIds.add(appContext.timestamp.toString());
    await prefs.setStringList(_processedTimestampsKey, processedIds);
  }

  Future<void> sendCircleData({
    required int circleMaxValue,
    required int circleCurrentValue,
  }) async {
    final appContext = AppContext(
      timestamp: DateTime.now().millisecondsSinceEpoch,
      type: ContextType.circleDataUpdate,
      data: {
        'circleMaxValue': circleMaxValue,
        'circleCurrentValue': circleCurrentValue,
      },
    );

    _watch.updateApplicationContext(appContext.toJson());
  }

  void dispose() {
    _subscription?.cancel();
  }
}