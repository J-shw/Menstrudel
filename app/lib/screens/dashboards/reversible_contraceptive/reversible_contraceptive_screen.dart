import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'package:provider/provider.dart';
import 'package:menstrudel/database/repositories/reversible_contraceptive_repository.dart';
import 'package:menstrudel/l10n/app_localizations.dart';
import 'package:menstrudel/models/birth_control/reversible_contraceptives/reversible_contraceptive_log_entry.dart';
import 'package:menstrudel/services/notification_service.dart';
import 'package:menstrudel/services/settings_service.dart';
import 'package:menstrudel/widgets/larcs/screen/larc_log_card.dart';
import 'package:menstrudel/controllers/log_larc_ui_controller.dart';
import 'package:timezone/timezone.dart' as tz;

class LarcScreen extends StatefulWidget {
  const LarcScreen({super.key});

  @override
  State<LarcScreen> createState() => _LarcScreenState();
}

class _LarcScreenState extends State<LarcScreen> {
  List<LarcLogEntry> _loggedLarcs = [];
  bool _isLoading = true;
  final larcRepo = LarcRepository();
  LogLarcUIController? _controller;

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final newController = context.read<LogLarcUIController>();
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
    if (_loggedLarcs.isEmpty) {
      setState(() { _isLoading = true; });
    }

    final loadedEntries = await larcRepo.getAllLogs();
    
    if (!mounted) return;
    setState(() {
      _loggedLarcs = loadedEntries;
      _isLoading = false;
    });

    await setLarcReminders();
  }

  Map<String, dynamic> _calculateLarcStatus(LarcLogEntry entry) {
    final settingsService = context.read<SettingsService>();
    final durationDays = settingsService.getLarcDurationDays(entry.type);
    DateTime nextDueDate = entry.date.add(Duration(days: durationDays));
    return {
      'nextDueDate': nextDueDate,
      'dueDateString': DateFormat('MMM d, yyyy').format(nextDueDate),
      'injectionDate': DateFormat('MMM d, yyyy').format(entry.date),
      'isOverdue': nextDueDate.isBefore(DateTime.now()),
      'isActive': nextDueDate.isAfter(DateTime.now()),
    };
  }

  Future<void> setLarcReminders() async {
    final settingsService = context.read<SettingsService>();
    final l10n = AppLocalizations.of(context)!;
    final List<Map<String, dynamic>> allStatuses = _loggedLarcs
        .map((entry) => _calculateLarcStatus(entry)..['entry'] = entry)
        .toList();

    final activeLarcs = allStatuses.where((status) => status['isActive'] == true).toList();
    if (activeLarcs.isEmpty) {
      await NotificationService.cancelLarcReminder();
      return;
    }

    activeLarcs.sort((a, b) => a['nextDueDate'].compareTo(b['nextDueDate']));
    final nextDueStatus = activeLarcs.first;
    final nextDueDate = nextDueStatus['nextDueDate'] as DateTime;
    final nextLarcType = (nextDueStatus['entry'] as LarcLogEntry).type;

    final scheduledTime = tz.TZDateTime.from(
      DateTime(nextDueDate.year, nextDueDate.month, nextDueDate.day,
          settingsService.larcReminderTime.hour, settingsService.larcReminderTime.minute),
      tz.local,
    ).subtract(Duration(days: settingsService.larcReminderDays));

    if (scheduledTime.isBefore(DateTime.now())) {
      await NotificationService.cancelLarcReminder();
      return;
    }

    await NotificationService.scheduleLarcReminder(
      reminderDateTime: scheduledTime,
      title: l10n.notification_larcTitle,
      body: l10n.notification_larcBody(nextLarcType.getDisplayName(l10n), settingsService.larcReminderDays),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;
    final controller = context.read<LogLarcUIController>();

    if (_isLoading) return const Center(child: CircularProgressIndicator());

    _loggedLarcs.sort((a, b) => b.date.compareTo(a.date));
    final List<Map<String, dynamic>> allStatuses = _loggedLarcs
        .map((entry) => _calculateLarcStatus(entry)..['entry'] = entry)
        .toList();
    
    final activeLarcs = allStatuses.where((s) => s['isActive']).toList();
    final historyLarcs = allStatuses.where((s) => !s['isActive']).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(l10n.larcScreen_activeLarcs(activeLarcs.length), colorScheme),
          const SizedBox(height: 12),
          if (activeLarcs.isEmpty)
            _buildNoRecordsText(l10n.larcScreen_noActiveRecords, colorScheme)
          else
            ...activeLarcs.map((s) => LarcLogCard(
                  entry: s['entry'],
                  l10n: l10n,
                  injectionDate: s['injectionDate'],
                  dueDateString: s['dueDateString'],
                  isOverdue: s['isOverdue'],
                  onTap: () => controller.handleEditLarcLog(context: context, entry: s['entry']),
                )),
          const SizedBox(height: 32),
          _buildHeader(l10n.larcScreen_history(historyLarcs.length), colorScheme),
          const SizedBox(height: 12),
          if (historyLarcs.isEmpty)
            _buildNoRecordsText(l10n.larcScreen_noHistoryRecords, colorScheme)
          else
            ...historyLarcs.map((s) => LarcLogCard(
                  entry: s['entry'],
                  l10n: l10n,
                  injectionDate: s['injectionDate'],
                  dueDateString: s['dueDateString'],
                  isOverdue: s['isOverdue'],
                  onTap: () => controller.handleEditLarcLog(context: context, entry: s['entry']),
                )),
        ],
      ),
    );
  }

  Widget _buildHeader(String title, ColorScheme colorScheme) => Text(title, 
      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: colorScheme.onSurface));

  Widget _buildNoRecordsText(String text, ColorScheme colorScheme) => Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Text(text, style: TextStyle(color: colorScheme.outline)));
}