import 'package:watch_connectivity/watch_connectivity.dart';

class WatchSyncService {
  final _watch = WatchConnectivity();

  Future<void> sendPrediction({required int daysUntilDue}) async {
    final data = <String, dynamic>{
      'daysUntilDue': daysUntilDue,
    };
    _watch.sendMessage(data);
  }
}