import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'package:provider/provider.dart';
import 'package:menstrudel/database/repositories/sex_repository.dart';
import 'package:menstrudel/l10n/app_localizations.dart';
import 'package:menstrudel/models/sex/sex_log_entry.dart';
import 'package:menstrudel/widgets/sex_activities/screen/sex_log_card.dart';
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

    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.sexActivityScreen_history(_loggedSexActivities.length),
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 12),
            if (_loggedSexActivities.isEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  l10n.sexActivityScreen_noSexActivityRecordsFound,
                  style: TextStyle(color: colorScheme.outline),
                ),
              )
            else
              ..._loggedSexActivities.map((log) {
                return SexLogCard(
                  entry: log,
                  l10n: l10n,
                  formattedDate: DateFormat.yMMMMd(Localizations.localeOf(context).languageCode)
                      .add_jm()
                      .format(log.dateTime),
                  onTap: () => controller.handleEditSexLog(context: context, entry: log),
                );
              }),
          ],
        ),
      ),
    );
  }
}