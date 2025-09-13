import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:watch_connectivity/watch_connectivity.dart';

class WatchSyncService {
  final _watch = WatchConnectivity();
  StreamSubscription? _subscription;

  void Function()? onPeriodLogRequested;

  Future<void> initialize({required void Function() onPeriodLog}) async {
    onPeriodLogRequested = onPeriodLog;

    debugPrint('Initialising and listening on applicationContextStream...');


    final missedContexts = await _watch.receivedApplicationContexts;
    for (final context in missedContexts) {
      _handleContext(context);
    }

    _subscription = _watch.contextStream.listen(_handleContext);
  }
  
  void _handleContext(Map<String, dynamic> context) {
    debugPrint('Processing context: $context');
    if (context['log_period'] == true) {
      onPeriodLogRequested?.call();
    }
  }

  Future<void> sendCircleData({
      required int circleMaxValue,
      required int circleCurrentValue,
    }) async {
    final data = <String, dynamic>{
      'circleMaxValue': circleMaxValue,
      'circleCurrentValue': circleCurrentValue,
    };
    _watch.sendMessage(data);
  }

  void dispose() {
    _subscription?.cancel();
  }
}