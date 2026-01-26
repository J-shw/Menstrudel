import 'package:flutter/material.dart';
import 'package:menstrudel/l10n/app_localizations.dart';
import 'package:menstrudel/models/sex/sex_log_entry.dart';
import 'package:menstrudel/models/sex/sex_type_enum.dart';
import 'package:menstrudel/models/sex/sex_protection_type_enum.dart';
import 'package:menstrudel/screens/dashboards/sex/widgets/sex_activity_chart.dart';
import 'package:menstrudel/screens/dashboards/sex/widgets/sex_activity_usage_chart.dart';
import 'package:menstrudel/screens/dashboards/sex/widgets/sex_protection_usage_chart.dart';
import 'package:menstrudel/widgets/insights/global/quick_stat_card.dart';

class SexInsightsTab extends StatelessWidget {
  final List<SexLogEntry> historyEntries;
  final bool isLoading;

  const SexInsightsTab({
    super.key,
    required this.historyEntries,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (isLoading) return const Center(child: CircularProgressIndicator());

    if (historyEntries.isEmpty) {
      return Center(
        child: Text(l10n.sexActivityScreen_noSexActivityRecordsFound),
      );
    }

    // Calculate Most Frequent Sex Type
    final typeCounts = <SexTypes, int>{};
    for (var entry in historyEntries) {
      if (entry.sexType != null) {
        typeCounts[entry.sexType!] = (typeCounts[entry.sexType!] ?? 0) + 1;
      }
    }
    final mostFreqType = typeCounts.isNotEmpty 
        ? typeCounts.entries.reduce((a, b) => a.value > b.value ? a : b).key 
        : null;

    // Calculate Most Used Protection
    final protCounts = <SexProtectionTypes, int>{};
    for (var entry in historyEntries) {
      if (entry.protectionType != SexProtectionTypes.none && entry.protectionType != null) {
        protCounts[entry.protectionType!] = (protCounts[entry.protectionType!] ?? 0) + 1;
      }
    }
    final primaryProt = protCounts.isNotEmpty
        ? protCounts.entries.reduce((a, b) => a.value > b.value ? a : b).key 
        : null;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.5,
            children: [
              QuickStatCard(
                label: l10n.totalLogs,
                value: historyEntries.length.toString(),
                icon: Icons.history,
              ),
              QuickStatCard(
                label: l10n.sexActivityScreen_primaryMethod,
                value: primaryProt?.getDisplayName(l10n) ?? l10n.sexProtection_none,
                icon: primaryProt?.icon ?? Icons.shield_outlined,
              ),
              QuickStatCard(
                label: l10n.sexActivityScreen_mostFrequent,
                value: mostFreqType?.getDisplayName(l10n) ?? l10n.other,
                icon: mostFreqType?.icon ?? Icons.favorite_outline,
              ),
              QuickStatCard(
                label: l10n.sexActivityScreen_protected,
                value: "${historyEntries.where((e) => e.protectionType != SexProtectionTypes.none && e.protectionType != null).length}",
                icon: Icons.verified_user_outlined,
              ),
            ],
          ),
          const SizedBox(height: 24),
          SexActivityChart(historyEntries: historyEntries),
          const SizedBox(height: 24),
          SexActivityUsageChart(historyEntries: historyEntries),
          const SizedBox(height: 24),
          SexProtectionUsageChart(historyEntries: historyEntries),
        ],
      ),
    );
  }
}