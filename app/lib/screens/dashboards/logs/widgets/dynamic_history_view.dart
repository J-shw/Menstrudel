import 'package:flutter/material.dart';
import 'package:menstrudel/screens/dashboards/logs/widgets/journal_view.dart';
import 'package:menstrudel/screens/dashboards/logs/widgets/list_view.dart';
import 'package:menstrudel/services/settings_service.dart';
import 'package:menstrudel/models/period_logs/log_day.dart';
import 'package:provider/provider.dart';

class DynamicHistoryView extends StatelessWidget {
final Function(DateTime) onLogRequested;
  final Function(LogDay) onLogTapped;

  const DynamicHistoryView({
    super.key,
    required this.onLogRequested,
    required this.onLogTapped,
  });

  @override
  Widget build(BuildContext context) {
    final settingsService = context.watch<SettingsService>();

    switch (settingsService.historyView) {
      case PeriodHistoryView.list:
        return PeriodListView(
          onLogTapped: onLogTapped,
        );
      case PeriodHistoryView.journal:
        return PeriodJournalView(
          onLogTapped: onLogTapped,
          onLogRequested: onLogRequested,
        );
    }
  }
}