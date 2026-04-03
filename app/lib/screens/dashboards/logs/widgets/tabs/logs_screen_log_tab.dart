import 'package:flutter/material.dart';
import 'package:menstrudel/controllers/log_ui_controller.dart';
import 'package:menstrudel/services/period_service.dart';
import 'package:menstrudel/screens/dashboards/logs/widgets/dynamic_history_view.dart';
import 'package:provider/provider.dart';

class LogsScreenLogTab extends StatefulWidget {
  final PeriodService periodService;
  final int? userAge;

  const LogsScreenLogTab({
    super.key,
    required this.periodService,
    required this.userAge,
  });

  @override
  State<LogsScreenLogTab> createState() => _LogsScreenLogTabState();
}

class _LogsScreenLogTabState extends State<LogsScreenLogTab> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final isLoading = widget.periodService.isLoading;

    if (isLoading) return const Center(child: CircularProgressIndicator());

    return DynamicHistoryView(
      onLogRequested: (date) {
        context.read<LogUIController>().handleCreateNewLog(
          context: context,
          selectedDate: date,
          symptomService: context.read(),
          age: widget.userAge,
        );
      },
      onLogTapped: (log) => context.read<LogUIController>().handleEditLog(
        context: context,
        log: log,
        symptomService: context.read(),
      ),
    );
  }
}