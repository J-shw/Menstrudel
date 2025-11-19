import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'package:menstrudel/database/repositories/larc_repository.dart';
import 'package:menstrudel/l10n/app_localizations.dart';
import 'package:menstrudel/models/birth_control/larcs/larc_log_entry.dart';
import 'package:menstrudel/models/birth_control/larcs/larc_types_enum.dart';
import 'package:menstrudel/services/settings_service.dart';
import 'package:menstrudel/widgets/larcs/screen/larc_log_card.dart';
import 'package:menstrudel/widgets/larcs/sheets/edit_larc_bottom_sheet.dart';
import 'package:menstrudel/widgets/larcs/sheets/log_larc_bottom_sheet.dart';
import 'package:provider/provider.dart';

class LarcScreen extends StatefulWidget {
  const LarcScreen({super.key});

  @override
  State<LarcScreen> createState() => _LarcScreenState();
}

class _LarcScreenState extends State<LarcScreen> {
  List<LarcLogEntry> _loggedLarcs = [];
  bool _isLoading = true;
  final larcRepo = LarcRepository();

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    setState(() { _isLoading = true; });

    final loadedEntries = await larcRepo.getAllLogs();
    setState(() {
      _loggedLarcs = loadedEntries;
      _isLoading = false;
    });
  }

  void _presentLogSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (ctx) {
      return LogLarcBottomSheet(
        onSave: (date, note) {
          _saveLarcLog(date: date, note: note);
        },
      );
    },
  );
}

  Future<void> _saveLarcLog({required DateTime date, required String? note}) async {
    final settingsService = context.read<SettingsService>();

    final newEntry = LarcLogEntry(
      id: null,
      date: date,
      type: settingsService.larcType,
      note: note,
    );

    await larcRepo.logLarc(newEntry);
    
    _loadHistory();
  }

  Future<void> _deleteLarcLog(int id) async {
  await larcRepo.deleteLog(id);
  _loadHistory();
}

void _presentEditDeleteSheet(BuildContext context, LarcLogEntry entry) {
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

Future<void> _updateLarcLog(LarcLogEntry updatedEntry) async {
  await larcRepo.updateLog(updatedEntry); 
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

    _loggedLarcs.sort((a, b) => b.date.compareTo(a.date));

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            Text(
              'History (${_loggedLarcs.length})', 
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface, 
              ),
            ),
            const SizedBox(height: 12),
            if (_loggedLarcs.isEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text('No records found.', style: TextStyle(color: colorScheme.outline)),
              )
            else
              ..._loggedLarcs.map((entry) {
                DateTime nextDueDate;
                String dueDateString;

                switch (entry.type) {
                  case LarcTypes.injection:
                    nextDueDate = entry.date.add(const Duration(days: 84));
                    break;
                  default:
                    nextDueDate = entry.date;
                }
                
                final injectionDate = DateFormat('MMM d, yyyy').format(entry.date);
                dueDateString = DateFormat('MMM d, yyyy').format(nextDueDate);
                
                final isOverdue = nextDueDate.isBefore(DateTime.now());
                
                Color dueDateColor = isOverdue 
                    ? colorScheme.error
                    : colorScheme.tertiary;

                return LarcLogCard(
                  entry: entry,
                  l10n: l10n,
                  injectionDate: injectionDate,
                  dueDateString: dueDateString,
                  dueDateColor: dueDateColor,
                  onTap: () => _presentEditDeleteSheet(context, entry),
                );
              }),
          ],
        ),
      ),
    );
  }
}