import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'package:menstrudel/database/repositories/sex_repository.dart';
import 'package:menstrudel/l10n/app_localizations.dart';
import 'package:menstrudel/models/sex/sex_log_entry.dart';
import 'package:menstrudel/models/sex/sex_participation_type_enum.dart';
import 'package:menstrudel/models/sex/sex_protection_type_enum.dart';
import 'package:menstrudel/models/sex/sex_type_enum.dart';
import 'package:menstrudel/widgets/sex_activities/screen/sex_log_card.dart';
import 'package:menstrudel/widgets/sex_activities/sheets/log_sex_activity_bottom_sheet.dart';
import 'package:menstrudel/widgets/sex_activities/sheets/sex_activity_details_bottom_sheet.dart';

/// Not the kind of screen you were expecting? Sorry to disappoint!
class SexScreen extends StatefulWidget {
  const SexScreen({super.key});

  @override
  State<SexScreen> createState() => _SexScreenState();
}

class _SexScreenState extends State<SexScreen> {
  List<SexLogEntry> _loggedSexActivities = [];
  bool _isLoading = true;
  final sexRepo = SexRepository();

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    setState(() { _isLoading = true; });

    final loadedEntries = await sexRepo.getAllLogs();
    setState(() {
      _loggedSexActivities = loadedEntries;
      _isLoading = false;
    });
  }

  void _presentLogSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (ctx) {
      return LogSexActivityBottomSheet(
        onSave: (dateTime, sexType, participationType, protectionType, note) {
          _saveSexLog(dateTime: dateTime, sexType: sexType, participationType: participationType, protectionType: protectionType, note: note);
        },
      );
    },
  );
}

  Future<void> _saveSexLog({required DateTime dateTime, required SexTypes? sexType, required SexParticipationTypes? participationType, required SexProtectionTypes? protectionType, required String? note}) async {
    final newEntry = SexLogEntry(
      id: null,
      dateTime: dateTime,
      sexType: sexType,
      participationType: participationType,
      protectionType: protectionType,
      note: note,
    );

    await sexRepo.logActivity(newEntry);
    
    _loadHistory();
  }

  Future<void> _deleteSexLog(int id) async {
    await sexRepo.deleteLog(id);
    _loadHistory();
  }

void _presentEditDeleteSheet(BuildContext context, SexLogEntry entry) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (ctx) {
      return EditSexLogBottomSheet(
        log: entry,
        onSave: (updatedEntry) {
          _updateSexLog(updatedEntry);
          Navigator.pop(context);
        },
        onDelete: () {
          _deleteSexLog(entry.id!);
          Navigator.pop(context);
        },
      );
    },
  );
}

  Future<void> _updateSexLog(SexLogEntry updatedEntry) async {
    await sexRepo.updateLog(updatedEntry); 
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

    final List<SexLogEntry> loggedSexActivities = _loggedSexActivities;
    

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(l10n.sexActivityScreen_history(loggedSexActivities.length), colorScheme),
            const SizedBox(height: 12),
            if (loggedSexActivities.isEmpty)
              _buildNoRecordsText(l10n.sexActivityScreen_noSexActivityRecordsFound, colorScheme)
            else
              ...loggedSexActivities.map((log) {
                return SexLogCard(
                  entry: log,
                  l10n: l10n,
                  formattedDate: DateFormat.yMMMMd(Localizations.localeOf(context).languageCode).add_jm().format(log.dateTime),
                  onTap: () => _presentEditDeleteSheet(context, log),
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