import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'package:menstrudel/database/repositories/sanitary_product_repository.dart';
import 'package:menstrudel/models/sanitary_products/sanitary_products_entry.dart';
import 'package:menstrudel/models/sanitary_products/sanitary_products_enum.dart';
import 'package:menstrudel/l10n/app_localizations.dart';
import 'package:menstrudel/services/notification_service.dart';
import 'package:menstrudel/services/settings_service.dart';
import 'package:menstrudel/widgets/sanitary_products/sheets/edit_sanitary_product_bottom_sheet.dart';
import 'package:menstrudel/widgets/sanitary_products/sheets/log_sanitary_product_bottom_sheet.dart';
import 'package:menstrudel/widgets/sanitary_products/screen/sanitary_product_log_card.dart';
import 'package:provider/provider.dart';
import 'package:timezone/timezone.dart' as tz;

class SanitaryScreen extends StatefulWidget {
  const SanitaryScreen({super.key});

  @override
  State<SanitaryScreen> createState() => _SanitaryScreenState();
}

class _SanitaryScreenState extends State<SanitaryScreen> {
  List<SanitaryProductsEntry> _loggedSanitaryProducts = [];
  bool _isLoading = true;
  final repo = SanitaryProductRepository();

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    setState(() { _isLoading = true; });

    final loadedEntries = await repo.getAllLogs();
    setState(() {
      _loggedSanitaryProducts = loadedEntries;
      _isLoading = false;
    });

    if (mounted) {
      await setLarcReminders();
    }
  }

  void _presentLogSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (ctx) {
      return LogLarcBottomSheet(
        onSave: (date, note) {
          _saveLog(date: date, note: note, type: SanitaryProducts.tampon);
        },
      );
    },
  );
}

  Future<void> _saveLog({required DateTime date, required String? note, required SanitaryProducts type}) async {

    final newEntry = SanitaryProductsEntry(
      id: null,
      date: date,
      type: type,
      note: note,
    );

    await repo.logSanitaryProduct(newEntry);
    
    _loadHistory();
  }

  Future<void> _deleteLarcLog(int id) async {
  await repo.deleteLog(id);
  _loadHistory();
}

void _presentEditDeleteSheet(BuildContext context, SanitaryProductsEntry entry) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (ctx) {
      return EditLarcLogBottomSheet(
        log: entry,
        onSave: (updatedEntry) {
          _updateLarcLog(updatedEntry);
          Navigator.pop(context);
        },
        onDelete: () {
          _deleteLarcLog(entry.id!);
          Navigator.pop(context);
        },
      );
    },
  );
}

Future<void> _updateLarcLog(SanitaryProductsEntry updatedEntry) async {
  await repo.updateLog(updatedEntry); 
  _loadHistory();
}

  Future<void> setLarcReminders() async {
    final settingsService = context.read<SettingsService>();
    final l10n = AppLocalizations.of(context)!;
    
    if (activeLarcs.isEmpty) {
        await NotificationService.cancelLarcReminder();
        return;
    }

    activeLarcs.sort((a, b) => a['nextDueDate'].compareTo(b['nextDueDate']));
    
    final nextDueStatus = activeLarcs.first;
    final nextDueDate = nextDueStatus['nextDueDate'] as DateTime;
    final nextLarcType = (nextDueStatus['entry'] as LarcLogEntry).type;
    final reminderDaysBefore = settingsService.larcReminderDays;
    final reminderTime = settingsService.larcReminderTime;
    final reminderHour = reminderTime.hour;
    final reminderMinute = reminderTime.minute;

    final nextDueDateAtTime = DateTime(
        nextDueDate.year, nextDueDate.month, nextDueDate.day,
        reminderHour, reminderMinute,
    );

    final finalScheduledTime = tz.TZDateTime.from(nextDueDateAtTime, tz.local)
  .subtract(Duration(days: reminderDaysBefore));


    if (finalScheduledTime.isBefore(DateTime.now())) {
      await NotificationService.cancelLarcReminder();
      debugPrint('LARC Notification date is in the past. Skipping notification schedule.');
      return;
    }

    await NotificationService.scheduleLarcReminder(
        reminderDateTime: finalScheduledTime, 
        title: l10n.notification_larcTitle, 
        body: l10n.notification_larcBody(
            nextLarcType.getDisplayName(l10n), 
            reminderDaysBefore,
        ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: _buildBody(colorScheme, l10n),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _presentLogSheet(context),
        backgroundColor: colorScheme.primaryContainer,
        child: Icon(Icons.add, color: colorScheme.onPrimaryContainer),
      ),
    );
  }

  Widget _buildBody(ColorScheme colorScheme, AppLocalizations l10n) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    _loggedSanitaryProducts.sort((a, b) => b.date.compareTo(a.date));

    final List<Map<String, dynamic>> allStatuses = _loggedSanitaryProducts
        .map((entry) => _calculateLarcStatus(entry)..['entry'] = entry)
        .toList();
    
    final activeLarcs = allStatuses.where((status) => status['isActive'] == true).toList();
    activeLarcs.sort((a, b) => a['nextDueDate'].compareTo(b['nextDueDate']));
    
    final historyLarcs = allStatuses.where((status) => status['isActive'] == false).toList();
    historyLarcs.sort((a, b) => b['entry'].date.compareTo(a['entry'].date));


    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(l10n.larcScreen_activeLarcs(activeLarcs.length), colorScheme),
            const SizedBox(height: 12),
            if (activeLarcs.isEmpty)
              _buildNoRecordsText(l10n.larcScreen_noActiveRecords, colorScheme)
            else
              ...activeLarcs.map((status) {
                return LarcLogCard(
                  entry: status['entry'],
                  l10n: l10n,
                  injectionDate: status['injectionDate'],
                  dueDateString: status['dueDateString'],
                  isOverdue: status['isOverdue'],
                  onTap: () => _presentEditDeleteSheet(context, status['entry']),
                );
              }),
            
            const SizedBox(height: 32),
            
            _buildHeader(l10n.larcScreen_history(historyLarcs.length), colorScheme),
            const SizedBox(height: 12),
            if (historyLarcs.isEmpty)
              _buildNoRecordsText(l10n.larcScreen_noHistoryRecords, colorScheme)
            else
              ...historyLarcs.map((status) {
                return LarcLogCard(
                  entry: status['entry'],
                  l10n: l10n,
                  injectionDate: status['injectionDate'],
                  dueDateString: status['dueDateString'],
                  isOverdue: status['isOverdue'],
                  onTap: () => _presentEditDeleteSheet(context, status['entry']),
                );
              }),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(String title, ColorScheme colorScheme) {
    return Text(
      title, 
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: colorScheme.onSurface, 
      ),
    );
  }

  Widget _buildNoRecordsText(String text, ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Text(text, style: TextStyle(color: colorScheme.outline)),
    );
  }
}