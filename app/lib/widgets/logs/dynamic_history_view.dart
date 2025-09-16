import 'package:flutter/material.dart';

import 'package:menstrudel/widgets/logs/list_view.dart';
import 'package:menstrudel/widgets/logs/journal_view.dart';
import 'package:menstrudel/services/settings_service.dart';
import 'package:menstrudel/models/period_logs/period_day.dart';
import 'package:menstrudel/models/periods/period.dart';
import 'package:menstrudel/models/period_prediction_result.dart';

class DynamicHistoryView extends StatelessWidget {
  final PeriodPredictionResult? predictionResult; 
  final PeriodHistoryView selectedView;
  final List<PeriodDay> periodLogEntries;
  final List<Period> periodEntries;
  final bool isLoading;
  final Function(int) onDelete;
  final Function(PeriodDay) onSave;
  final Function(DateTime) onLogRequested;
  final Function(PeriodDay) onLogTapped;

  const DynamicHistoryView({
    super.key,
    required this.predictionResult,
    required this.selectedView,
    required this.periodLogEntries,
    required this.periodEntries,
    required this.isLoading,
    required this.onDelete,
    required this.onSave,
    required this.onLogRequested,
    required this.onLogTapped,
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
          onLogTapped: onLogTapped,
        );
      case PeriodHistoryView.journal:
        return PeriodJournalView(
          periodLogEntries: periodLogEntries,
          predictionResult: predictionResult, 
          isLoading: isLoading,
          onDelete: onDelete,
          onSave: onSave,
          onLogRequested: onLogRequested,
        );
    }
  }
}