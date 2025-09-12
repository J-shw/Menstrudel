import 'package:shared_preferences/shared_preferences.dart';

class WearPredictionData {
  final int daysUntilDue;

  WearPredictionData({required this.daysUntilDue});
}

class WearSyncService {
  static const _keyDaysUntilDue = 'wear_daysUntilDue';

  Future<void> savePrediction({required int daysUntilDue}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyDaysUntilDue, daysUntilDue);
  }

  Future<WearPredictionData> readPrediction() async {
    final prefs = await SharedPreferences.getInstance();
    final days = prefs.getInt(_keyDaysUntilDue) ?? -1;
    return WearPredictionData(daysUntilDue: days);
  }
}