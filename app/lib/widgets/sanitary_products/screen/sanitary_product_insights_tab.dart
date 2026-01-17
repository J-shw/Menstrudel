import 'package:flutter/material.dart';
import 'package:menstrudel/l10n/app_localizations.dart';
import 'package:menstrudel/models/sanitary_products/sanitary_products_entry.dart';
import 'package:menstrudel/models/sanitary_products/sanitary_products_enum.dart';
import 'package:menstrudel/widgets/insights/global/quick_stat_card.dart';
import 'package:menstrudel/widgets/sanitary_products/inights/sanitary_product_usage_chart.dart';

class SanitaryProductInsightsTab extends StatelessWidget {
  final List<SanitaryProductsEntry> historyEntries;
  final bool isLoading;

  const SanitaryProductInsightsTab({
    super.key,
    required this.historyEntries,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final counts = <SanitaryProducts, int>{};

    if (isLoading) return const Center(child: CircularProgressIndicator());

    if (historyEntries.isEmpty) {
      return Center(
        child: Text(l10n.sanitaryProductsScreen_noHistoryRecords),
      );
    }

    for (var entry in historyEntries) {
      counts[entry.type] = (counts[entry.type] ?? 0) + 1;
    }

    final mostUsedType = counts.entries
        .reduce((a, b) => a.value > b.value ? a : b)
        .key;

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
                label: l10n.sanitaryProducts_mostUsed,
                value: mostUsedType.getDisplayName(l10n),
                icon: Icons.star_outline,
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          SanitaryProductUsageChart(historyEntries: historyEntries),
        ],
      ),
    );
  }
}