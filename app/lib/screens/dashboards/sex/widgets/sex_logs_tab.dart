import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:menstrudel/l10n/app_localizations.dart';
import 'package:menstrudel/models/sex/sex_log_entry.dart';
import 'package:menstrudel/widgets/sex_activities/screen/sex_log_card.dart';

class SexLogsTab extends StatelessWidget {
  final bool isLoading;
  final List<SexLogEntry> historyEntries;
  final Function(SexLogEntry) onTapEntry;

  const SexLogsTab({
    super.key,
    required this.isLoading,
    required this.historyEntries,
    required this.onTapEntry,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;

    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.sexActivityScreen_history(historyEntries.length),
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 12),
            if (historyEntries.isEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  l10n.sexActivityScreen_noSexActivityRecordsFound,
                  style: TextStyle(color: colorScheme.outline),
                ),
              )
            else
              ...historyEntries.map((log) {
                return SexLogCard(
                  entry: log,
                  l10n: l10n,
                  formattedDate: DateFormat.yMMMMd(Localizations.localeOf(context).languageCode)
                      .add_jm()
                      .format(log.dateTime),
                  onTap: () => onTapEntry(log),
                );
              }),
          ],
        ),
      ),
    );
  }
}