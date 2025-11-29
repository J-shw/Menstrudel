import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'package:menstrudel/database/repositories/sanitary_product_repository.dart';
import 'package:menstrudel/models/sanitary_products/sanitary_products_entry.dart';
import 'package:menstrudel/models/sanitary_products/sanitary_products_enum.dart';
import 'package:menstrudel/l10n/app_localizations.dart';
import 'package:menstrudel/services/notification_service.dart';
import 'package:menstrudel/widgets/sanitary_products/sheets/edit_sanitary_product_bottom_sheet.dart';
import 'package:menstrudel/widgets/sanitary_products/sheets/log_sanitary_product_bottom_sheet.dart';
import 'package:menstrudel/widgets/sanitary_products/screen/sanitary_product_log_card.dart';
import 'package:menstrudel/widgets/sanitary_products/screen/countdown_card.dart'; 

class SanitaryScreen extends StatefulWidget {
  const SanitaryScreen({super.key});

  @override
  State<SanitaryScreen> createState() => _SanitaryScreenState();
}

class _SanitaryScreenState extends State<SanitaryScreen> {
  List<SanitaryProductsEntry> _loggedSanitaryProducts = [];
  SanitaryProductsEntry? _activeEntry;
  bool _isLoading = true;
  final repo = SanitaryProductRepository();
  Timer? _uiTimer;

  @override
  void initState() {
    super.initState();
    _loadHistory();
    _uiTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _uiTimer?.cancel();
    super.dispose();
  }

  Future<void> _loadHistory() async {
    setState(() { _isLoading = true; });

    final loadedEntries = await repo.getInactiveLogs();
    final activeEntry = await repo.getActiveEntry();


    setState(() {
      _loggedSanitaryProducts = loadedEntries;
      _activeEntry = activeEntry;
      _isLoading = false;
    });
    if (!mounted) return;
    if (activeEntry != null) {
      final l10n = AppLocalizations.of(context)!;
      await _scheduleNotifications(l10n, activeEntry.reminderTime, activeEntry.type);
    } else {
      await NotificationService.cancelSanitaryProductReminder(); 
    }
    
  }

  Future<void> _scheduleNotifications(AppLocalizations l10n, DateTime reminderDateTime, SanitaryProducts type) async {
     await NotificationService.cancelSanitaryProductReminder();
     final activeEntry = _activeEntry;
     if (activeEntry != null) {
       final endTime = activeEntry.reminderTime;
       if (endTime.isAfter(DateTime.now())) {
          await NotificationService.scheduleSanitaryProductReminder(
            reminderDateTime: reminderDateTime,
            title: l10n.notification_SanitaryProductReminderTitle,
            body: l10n.notification_SanitaryProductReminderBody,
          );
       }
     }
  }

  void _presentLogSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) {
        return LogSanitaryProductBottomSheet(
          onSave: (logTime, note, type, reminderEndTime) {
            _saveLog(logTime: logTime, note: note, type: type, reminderEndTime: reminderEndTime);
          },
        );
      },
    );
  }

  Future<void> _saveLog({required DateTime logTime, required String? note, required SanitaryProducts type, required DateTime reminderEndTime}) async {

    final newEntry = SanitaryProductsEntry(
      id: null,
      logTime: logTime,
      reminderTime: reminderEndTime,
      type: type,
      note: note,
    );

    await repo.logSanitaryProduct(newEntry);
    _loadHistory();
  }

  Future<void> _deleteLog(int id) async {
    await repo.deleteLog(id);
    _loadHistory();
  }

  void _presentEditDeleteSheet(BuildContext context, SanitaryProductsEntry entry) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) {
        return EditSanitaryProductBottomSheet(
          log: entry,
          onSave: (updatedEntry) {
            _updateLog(updatedEntry);
            Navigator.pop(context);
          },
          onDelete: () {
            _deleteLog(entry.id!);
            Navigator.pop(context);
          },
        );
      },
    );
  }

  Future<void> _updateLog(SanitaryProductsEntry updatedEntry) async {
    await repo.updateLog(updatedEntry); 
    _loadHistory();
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

    final activeEntry = _activeEntry;
    
    
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- Countdown Section ---
              if (activeEntry != null) ...[
                CountdownCard(
                  entry: activeEntry,
                  l10n: l10n,
                  onCancel: () async {
                    await _deleteLog(activeEntry.id!);
                  },
                  onRemove: () async {
                    await repo.markEntryAsRemoved(activeEntry.id!, DateTime.now());
                    _loadHistory();
                  },
                ),
                const SizedBox(height: 24),
              ],

              // --- History Section ---
              Text(
                l10n.sanitaryProductsScreen_history(_loggedSanitaryProducts.length),
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface, 
                ),
              ),
              const SizedBox(height: 12),
              
              if (_loggedSanitaryProducts.isEmpty)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Text(l10n.sanitaryProductsScreen_noHistoryRecords, style: TextStyle(color: colorScheme.outline)),
                  ),
                )
              else
                ..._loggedSanitaryProducts.map((entry) {
                  final dateStr = DateFormat('MMM d, h:mm a').format(entry.logTime);

                  return SanitaryProductsLogCard(
                    entry: entry,
                    l10n: l10n,
                    logDate: dateStr,
                    onTap: () => _presentEditDeleteSheet(context, entry),
                  );
                }),
                
              // Space for FAB
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }
}