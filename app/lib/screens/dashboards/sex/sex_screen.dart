import 'package:flutter/material.dart';
import 'package:menstrudel/screens/dashboards/sex/widgets/sex_insights_tab.dart';
import 'package:menstrudel/screens/dashboards/sex/widgets/sex_logs_tab.dart';
import 'dart:async';
import 'package:provider/provider.dart';
import 'package:menstrudel/database/repositories/sex_repository.dart';
import 'package:menstrudel/l10n/app_localizations.dart';
import 'package:menstrudel/models/sex/sex_log_entry.dart';
import 'package:menstrudel/controllers/log_sex_ui_controller.dart';

class SexScreen extends StatefulWidget {
  const SexScreen({super.key});

  @override
  State<SexScreen> createState() => _SexScreenState();
}

class _SexScreenState extends State<SexScreen> {
  List<SexLogEntry> _loggedSexActivities = [];
  bool _isLoading = true;
  final sexRepo = SexRepository();
  LogSexUIController? _controller;

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final newController = context.read<LogSexUIController>();
    if (_controller != newController) {
      _controller?.removeListener(_loadHistory);
      _controller = newController;
      _controller?.addListener(_loadHistory);
    }
  }

  @override
  void dispose() {
    _controller?.removeListener(_loadHistory);
    super.dispose();
  }

  Future<void> _loadHistory() async {
    if (!mounted) return;
    if (_loggedSexActivities.isEmpty) {
      setState(() { _isLoading = true; });
    }

    final loadedEntries = await sexRepo.getAllLogs();
    
    if (!mounted) return;
    setState(() {
      _loggedSexActivities = loadedEntries;
      _isLoading = false;
    });
  }

  @override
Widget build(BuildContext context) {
  final colorScheme = Theme.of(context).colorScheme;
  final l10n = AppLocalizations.of(context)!;
  final controller = context.read<LogSexUIController>();

  return DefaultTabController(
    length: 2,
    child: Column(
      children: [
        TabBar(
          labelColor: colorScheme.primary,
          unselectedLabelColor: colorScheme.onSurfaceVariant,
          indicatorSize: TabBarIndicatorSize.tab,
          tabs: [
            Tab(text: l10n.logs),
            Tab(text: l10n.insights),
          ],
        ),
        Expanded(
          child: TabBarView(
            children: [
              SexLogsTab(
                isLoading: _isLoading,
                historyEntries: _loggedSexActivities,
                onTapEntry: (entry) => controller.handleEditSexLog(
                  context: context, 
                  entry: entry,
                ),
              ),
              SexInsightsTab(
                isLoading: _isLoading,
                historyEntries: _loggedSexActivities,
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
}