import 'package:flutter/material.dart';
import 'package:menstrudel/controllers/log_ui_controller.dart';
import 'package:menstrudel/services/period_service.dart';
import 'package:menstrudel/widgets/logs/dynamic_history_view.dart';
import 'package:provider/provider.dart';

class LogsScreenLogTab extends StatelessWidget {
  final PeriodService periodService;

  const LogsScreenLogTab({
    super.key,
    required this.periodService,
  });

  @override
  Widget build(BuildContext context) {
    final isLoading = periodService.isLoading;

    if (isLoading) return const Center(child: CircularProgressIndicator());

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child:Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DynamicHistoryView(
          onLogRequested: (date) {
            context.read<LogUIController>().handleCreateNewLog(
              context: context,
              selectedDate: date,
            );
          },
          onLogTapped: (log) => context.read<LogUIController>().handleEditLog(
            context: context,
            log: log,
          ),
        ),
      ],
      ),
    );
  }
}
