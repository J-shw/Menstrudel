import 'package:watch_connectivity/watch_connectivity.dart';

class WatchSyncService {
  final _watch = WatchConnectivity();

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
}