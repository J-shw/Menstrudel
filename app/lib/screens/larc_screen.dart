import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'package:menstrudel/database/repositories/larc_repository.dart';
import 'package:menstrudel/l10n/app_localizations.dart';
import 'package:menstrudel/models/birth_control/larcs/larc_log_entry.dart';
import 'package:menstrudel/models/birth_control/larcs/larc_types_enum.dart';
import 'package:menstrudel/services/settings_service.dart';
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

  Future<void> _saveLarcLog({required DateTime date, required String note}) async {
    final settingsService = context.read<SettingsService>();

    final newEntry = LarcLogEntry(
      id: null,
      date: date,
      type: settingsService.larcType,
    );

    await larcRepo.logLarc(newEntry);
    
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
        backgroundColor: colorScheme.secondaryContainer,
        child: Icon(Icons.add, color: colorScheme.onSecondaryContainer),
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
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: colorScheme.primary,
              ),
            ),
            const SizedBox(height: 8),
            if (_loggedLarcs.isEmpty)
              const Text('No records found.')
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

                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 4.0),
                  elevation: 2,
                  color: colorScheme.secondaryContainer,
                  child: ListTile(
                    leading: Icon(entry.type.getIcon(), color: colorScheme.onSecondaryContainer),
                    title: Text( 
                      entry.type.getDisplayName(l10n),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Date: $injectionDate'),
                        Text(
                          'Next Due: $dueDateString',
                          style: TextStyle(
                            color: nextDueDate.isBefore(DateTime.now())
                                ? Colors.red
                                : Colors.green,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    onTap: () {
                      // TODO: Handle tap action
                    },
                  ),
                );
              })
          ],
        ),
      ),
    );
  }
}