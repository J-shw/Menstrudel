import 'package:flutter/material.dart';

import 'package:menstrudel/widgets/logs/list_view.dart';
import 'package:menstrudel/widgets/logs/rhythm_view.dart';
import 'package:menstrudel/widgets/logs/journal_view.dart';
import 'package:menstrudel/services/settings_service.dart';
import 'package:menstrudel/models/period_logs/period_logs.dart';
import 'package:menstrudel/models/periods/period.dart';

class DynamicHistoryView extends StatelessWidget {
  final PeriodHistoryView selectedView;
  final List<PeriodLogEntry> periodLogEntries;
  final List<PeriodEntry> periodEntries;
  final bool isLoading;
  final Function(int) onDelete;

  const DynamicHistoryView({
    super.key,
    required this.selectedView,
    required this.periodLogEntries,
    required this.periodEntries,
    required this.isLoading,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    switch (selectedView) {
      case PeriodHistoryView.list:
        return PeriodListView(
          periodLogEntries: periodLogEntries,
          periodEntries: periodEntries,
          isLoading: isLoading,
          onDelete: onDelete,
        );
      case PeriodHistoryView.rhythm:
        return RhythmView(
          periodLogEntries: periodLogEntries,
          isLoading: isLoading,
          onDelete: onDelete,
        );
      case PeriodHistoryView.journal:
        return PeriodJournalView(
          periodLogEntries: periodLogEntries,
          isLoading: isLoading,
          onDelete: onDelete,
        );
    }
  }
}