import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'package:provider/provider.dart';
import 'package:menstrudel/database/repositories/reversible_contraceptive_repository.dart';
import 'package:menstrudel/screens/dashboards/reversible_contraceptive/widgets/reversible_contraceptive_log_card.dart';
import 'package:menstrudel/l10n/app_localizations.dart';
import 'package:menstrudel/models/birth_control/reversible_contraceptives/reversible_contraceptive_log_entry.dart';
import 'package:menstrudel/services/notification_service.dart';
import 'package:menstrudel/services/settings_service.dart';
import 'package:menstrudel/controllers/log_reversible_contraceptive_ui_controller.dart';
import 'package:timezone/timezone.dart' as tz;

class ReversibleContraceptiveScreen extends StatefulWidget {
  const ReversibleContraceptiveScreen({super.key});

  @override
  State<ReversibleContraceptiveScreen> createState() => _ReversibleContraceptiveScreenState();
}

class _ReversibleContraceptiveScreenState extends State<ReversibleContraceptiveScreen> {
  List<ReversibleContraceptiveLogEntry> _loggedReversibleContraceptives = [];
  bool _isLoading = true;
  final reversibleContraceptiveRepo = ReversibleContraceptiveRepository();
  LogReversibleContraceptiveUIController? _controller;

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final newController = context.read<LogReversibleContraceptiveUIController>();
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
    if (_loggedReversibleContraceptives.isEmpty) {
      setState(() { _isLoading = true; });
    }

    final loadedEntries = await reversibleContraceptiveRepo.getAllLogs();
    
    if (!mounted) return;
    setState(() {
      _loggedReversibleContraceptives = loadedEntries;
      _isLoading = false;
    });

    await setReversibleContraceptiveReminders();
  }

  Map<String, dynamic> _calculateReversibleContraceptiveStatus(ReversibleContraceptiveLogEntry entry) {
    final settingsService = context.read<SettingsService>();
    final durationDays = settingsService.getReversibleContraceptiveDurationDays(entry.type);
    DateTime nextDueDate = entry.date.add(Duration(days: durationDays));
    return {
      'nextDueDate': nextDueDate,
      'dueDateString': DateFormat('MMM d, yyyy').format(nextDueDate),
      'injectionDate': DateFormat('MMM d, yyyy').format(entry.date),
      'isOverdue': nextDueDate.isBefore(DateTime.now()),
      'isActive': nextDueDate.isAfter(DateTime.now()),
    };
  }

  Future<void> setReversibleContraceptiveReminders() async {
    final settingsService = context.read<SettingsService>();
    final l10n = AppLocalizations.of(context)!;
    final List<Map<String, dynamic>> allStatuses = _loggedReversibleContraceptives
        .map((entry) => _calculateReversibleContraceptiveStatus(entry)..['entry'] = entry)
        .toList();

    final activeReversibleContraceptives = allStatuses.where((status) => status['isActive'] == true).toList();
    if (activeReversibleContraceptives.isEmpty) {
      await NotificationService.cancelReversibleContraceptiveReminder();
      return;
    }

    activeReversibleContraceptives.sort((a, b) => a['nextDueDate'].compareTo(b['nextDueDate']));
    final nextDueStatus = activeReversibleContraceptives.first;
    final nextDueDate = nextDueStatus['nextDueDate'] as DateTime;
    final nextReversibleContraceptiveType = (nextDueStatus['entry'] as ReversibleContraceptiveLogEntry).type;

    final scheduledTime = tz.TZDateTime.from(
      DateTime(nextDueDate.year, nextDueDate.month, nextDueDate.day,
          settingsService.reversibleContraceptiveReminderTime.hour, settingsService.reversibleContraceptiveReminderTime.minute),
      tz.local,
    ).subtract(Duration(days: settingsService.reversibleContraceptiveReminderDays));

    if (scheduledTime.isBefore(DateTime.now())) {
      await NotificationService.cancelReversibleContraceptiveReminder();
      return;
    }

    await NotificationService.scheduleReversibleContraceptiveReminder(
      reminderDateTime: scheduledTime,
      title: l10n.notification_reversibleContraceptiveTitle,
      body: l10n.notification_reversibleContraceptiveBody(nextReversibleContraceptiveType.getDisplayName(l10n), settingsService.reversibleContraceptiveReminderDays),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;
    final controller = context.read<LogReversibleContraceptiveUIController>();

    if (_isLoading) return const Center(child: CircularProgressIndicator());

    _loggedReversibleContraceptives.sort((a, b) => b.date.compareTo(a.date));
    final List<Map<String, dynamic>> allStatuses = _loggedReversibleContraceptives
        .map((entry) => _calculateReversibleContraceptiveStatus(entry)..['entry'] = entry)
        .toList();
    
    final activeReversibleContraceptives = allStatuses.where((s) => s['isActive']).toList();
    final historyReversibleContraceptives = allStatuses.where((s) => !s['isActive']).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(l10n.reversibleContraceptiveScreen_activeReversibleContraceptives(activeReversibleContraceptives.length), colorScheme),
          const SizedBox(height: 12),
          if (activeReversibleContraceptives.isEmpty)
            _buildNoRecordsText(l10n.reversibleContraceptiveScreen_noActiveRecords, colorScheme)
          else
            ...activeReversibleContraceptives.map((s) => ReversibleContraceptiveLogCard(
                  entry: s['entry'],
                  l10n: l10n,
                  injectionDate: s['injectionDate'],
                  dueDateString: s['dueDateString'],
                  isOverdue: s['isOverdue'],
                  onTap: () => controller.handleEditReversibleContraceptiveLog(context: context, entry: s['entry']),
                )),
          const SizedBox(height: 32),
          _buildHeader(l10n.reversibleContraceptiveScreen_history(historyReversibleContraceptives.length), colorScheme),
          const SizedBox(height: 12),
          if (historyReversibleContraceptives.isEmpty)
            _buildNoRecordsText(l10n.reversibleContraceptiveScreen_noHistoryRecords, colorScheme)
          else
            ...historyReversibleContraceptives.map((s) => ReversibleContraceptiveLogCard(
                  entry: s['entry'],
                  l10n: l10n,
                  injectionDate: s['injectionDate'],
                  dueDateString: s['dueDateString'],
                  isOverdue: s['isOverdue'],
                  onTap: () => controller.handleEditReversibleContraceptiveLog(context: context, entry: s['entry']),
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