import 'package:flutter/foundation.dart';
import 'package:home_widget/home_widget.dart';

class WidgetController {
  
  final String _androidWidgetName = 'HomeScreenWidgetProvider';
  final String _iOSWidgetName = 'widgetNameHere'; // Saved for iOS use

  Future<void> saveData(String title, String message) async {
    try {
      await HomeWidget.saveWidgetData<String>('widget_title', title);
      await HomeWidget.saveWidgetData<String>('widget_message', message);
    } catch (e) {
      debugPrint('Error saving widget data: $e');
    }
  }
  /// Updates widget data
  Future<void> updateWidget() async {
    try {
      await HomeWidget.updateWidget(
        androidName: _androidWidgetName,
        iOSName: _iOSWidgetName,
      );
    } catch (e) {
      debugPrint('Error updating widget: $e');
    }
  }

  /// Saves data and then immediately triggers an update.
  Future<void> saveAndAndUpdate(String title, String message) async {
    await saveData(title, message);
    await updateWidget();
  }
}