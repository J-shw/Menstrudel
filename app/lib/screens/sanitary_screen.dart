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

class SanitaryScreen extends StatefulWidget {
  const SanitaryScreen({super.key});

  @override
  State<SanitaryScreen> createState() => _SanitaryScreenState();
}

class _SanitaryScreenState extends State<SanitaryScreen> {
  List<SanitaryProductsEntry> _loggedSanitaryProducts = [];
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

    final loadedEntries = await repo.getAllLogs();
    
    loadedEntries.sort((a, b) => b.date.compareTo(a.date));

    setState(() {
      _loggedSanitaryProducts = loadedEntries;
      _isLoading = false;
    });
    if (!mounted) return;

    if (loadedEntries.isNotEmpty) {
      final latestEntry = loadedEntries.first;
      final now = DateTime.now();
      final dueDateTime = latestEntry.date.add(
        Duration(hours: latestEntry.type.defaultDurationHours)
      );

      if (dueDateTime.isAfter(now)) {
        final l10n = AppLocalizations.of(context)!;
        await _scheduleNotifications(l10n, dueDateTime, latestEntry.type);
      } else {
        await NotificationService.cancelSanitaryProductReminder(); 
      }
    }
  }

  Future<void> _scheduleNotifications(AppLocalizations l10n, DateTime reminderDateTime, SanitaryProducts type) async {
     await NotificationService.cancelSanitaryProductReminder();
     
     final activeEntry = _getActiveEntry();
     if (activeEntry != null) {
       final endTime = activeEntry.date.add(Duration(hours: activeEntry.type.defaultDurationHours));
       if (endTime.isAfter(DateTime.now())) {
          await NotificationService.scheduleSanitaryProductReminder(
            reminderDateTime: reminderDateTime,
            title: l10n.notification_SanitaryProductReminderTitle,
            body: l10n.notification_SanitaryProductReminderBody,
          );
       }
     }
  }

  SanitaryProductsEntry? _getActiveEntry() {
    if (_loggedSanitaryProducts.isEmpty) return null;
    final latest = _loggedSanitaryProducts.first;
    final endTime = latest.date.add(Duration(hours: latest.type.defaultDurationHours));
    
    if (endTime.isAfter(DateTime.now())) {
      return latest;
    }
    return null;
  }

  void _presentLogSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) {
        return LogSanitaryProductBottomSheet(
          onSave: (time, note, type) {
            _saveLog(time: time, note: note, type: type);
          },
        );
      },
    );
  }

  Future<void> _saveLog({required TimeOfDay time, required String? note, required SanitaryProducts type}) async {
    final now = DateTime.now();
    var date = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    
    if (date.isAfter(now)) {
      date = date.subtract(const Duration(days: 1));
    }

    final newEntry = SanitaryProductsEntry(
      id: null,
      date: date,
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

    final activeEntry = _getActiveEntry();
    
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- Countdown Section ---
              if (activeEntry != null) ...[
                _buildCountdownCard(context, activeEntry, l10n),
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
                  final dateStr = DateFormat('MMM d, h:mm a').format(entry.date);

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

  Widget _buildCountdownCard(BuildContext context, SanitaryProductsEntry entry, AppLocalizations l10n) {
    final theme = Theme.of(context);
    final endTime = entry.date.add(Duration(hours: entry.type.defaultDurationHours));
    final remaining = endTime.difference(DateTime.now());
    
    // Don't show negative if something weird happens, though _getActiveEntry filters this
    final displayDuration = remaining.isNegative ? Duration.zero : remaining;
    
    final hours = displayDuration.inHours.toString().padLeft(2, '0');
    final minutes = displayDuration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = displayDuration.inSeconds.remainder(60).toString().padLeft(2, '0');

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [theme.colorScheme.primaryContainer, theme.colorScheme.surface],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(entry.type.getIcon(), color: theme.colorScheme.primary),
              const SizedBox(width: 8),
              Text(
                "Active ${entry.type.getDisplayName(l10n)}",
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.bold
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            "$hours:$minutes:$seconds",
            style: theme.textTheme.displayMedium?.copyWith(
              fontWeight: FontWeight.bold,
              fontFamily: 'monospace', // Monospace prevents jittering as numbers change
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Change due at ${DateFormat.jm().format(endTime)}",
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant
            ),
          ),
          const SizedBox(height: 20),
          FilledButton.icon(
            onPressed: () => _deleteLog(entry.id!),
            icon: const Icon(Icons.close),
            label: Text(l10n.cancel),
            style: FilledButton.styleFrom(
              backgroundColor: theme.colorScheme.errorContainer,
              foregroundColor: theme.colorScheme.onErrorContainer,
            ),
          ),
        ],
      ),
    );
  }
}