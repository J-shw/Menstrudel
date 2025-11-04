import 'package:flutter/material.dart';

import 'package:menstrudel/widgets/logs/list_view.dart';
import 'package:menstrudel/widgets/logs/journal_view.dart';
import 'package:menstrudel/services/settings_service.dart';
import 'package:menstrudel/models/period_logs/period_day.dart';
import 'package:provider/provider.dart';

class DynamicHistoryView extends StatelessWidget {
final Function(DateTime) onLogRequested;
  final Function(PeriodDay) onLogTapped;

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