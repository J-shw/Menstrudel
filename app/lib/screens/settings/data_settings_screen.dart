import 'package:flutter/material.dart';
import 'package:menstrudel/database/repositories/periods_repository.dart';
import 'package:menstrudel/l10n/app_localizations.dart';
import 'package:menstrudel/widgets/dialogs/delete_confirmation_dialog.dart';

class DataSettingsScreen extends StatefulWidget {
  const DataSettingsScreen({super.key});

  @override
  State<DataSettingsScreen> createState() => _DataSettingsScreenState();
}

class _DataSettingsScreenState extends State<DataSettingsScreen> {
  final periodsRepo = PeriodsRepository();
  bool _isLoading = false;

  Future<void> clearLogs() async {
    setState(() { _isLoading = true; });

    await periodsRepo.deleteAllEntries();

    if (!mounted) return;

    final l10n = AppLocalizations.of(context)!;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.settingsScreen_allLogsHaveBeenCleared)),
    );
    
    Navigator.of(context).pop(); 

    setState(() { _isLoading = false; });
  }

  Future<void> showClearLogsDialog() async {
    final l10n = AppLocalizations.of(context)!;
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return ConfirmationDialog(
          title: l10n.settingsScreen_clearAllLogs_question,
          content: Text(
            l10n.settingsScreen_deleteAllLogsDescription,
          ),
          confirmButtonText: l10n.clear,
          onConfirm: clearLogs,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settingsScreen_dataManagement),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              children: [
                ListTile(
                  leading: Icon(
                    Icons.delete_forever_outlined,
                    color: Theme.of(context).colorScheme.error,
                  ),
                  title: Text(
                    l10n.settingsScreen_clearAllLogs,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                  onTap: showClearLogsDialog,
                ),
              ],
            ),
    );
  }
}