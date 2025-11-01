import 'package:flutter/foundation.dart';
import 'package:home_widget/home_widget.dart';

class WidgetController {
  
  final String _androidWidgetName = 'HomeScreenWidgetProvider';
  final String _iOSWidgetName = 'widgetNameHere'; // Saved for iOS use

  /// Saves and updates all data for the circle widget.
  Future<void> saveAndAndUpdateCircle({
    required int currentValue,
    required int maxValue,
    required String largeText,
    required String smallText,
  }) async {
    try {
      await HomeWidget.saveWidgetData<int>('widget_current_value', currentValue);
      await HomeWidget.saveWidgetData<int>('widget_max_value', maxValue);
      await HomeWidget.saveWidgetData<String>('widget_large_text', largeText);
      await HomeWidget.saveWidgetData<String>('widget_small_text', smallText);

      await HomeWidget.updateWidget(
        androidName: _androidWidgetName,
        iOSName: _iOSWidgetName,
      );
    } catch (e) {
      debugPrint('Error saving and updating circle widget: $e');
    }
  }
}