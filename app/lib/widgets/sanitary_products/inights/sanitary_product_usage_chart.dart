import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:menstrudel/models/sanitary_products/sanitary_products_entry.dart';
import 'package:menstrudel/models/sanitary_products/sanitary_products_enum.dart';
import 'package:menstrudel/l10n/app_localizations.dart';

class SanitaryProductUsageChart extends StatelessWidget {
  final List<SanitaryProductsEntry> historyEntries;

  const SanitaryProductUsageChart({super.key, required this.historyEntries});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;
    final now = DateTime.now();
    final last7Days = List.generate(7, (i) => now.subtract(Duration(days: 6 - i)));
    final usedTypes = historyEntries.map((e) => e.type).toSet().toList();

    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.sanitaryProducts_usageTrend,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            AspectRatio(
              aspectRatio: 1.7,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  barGroups: List.generate(7, (index) {
                    final day = last7Days[index];
                    final dayKey = DateFormat('yyyy-MM-dd').format(day);
                    
                    final dayEntries = historyEntries.where((e) => 
                      DateFormat('yyyy-MM-dd').format(e.logTime) == dayKey
                    ).toList();

                    final typeCounts = <SanitaryProducts, int>{};
                    for (var e in dayEntries) {
                      typeCounts[e.type] = (typeCounts[e.type] ?? 0) + 1;
                    }

                    double currentY = 0;
                    return BarChartGroupData(
                      x: index,
                      barRods: [
                        BarChartRodData(
                          toY: dayEntries.length.toDouble(),
                          width: 18,
                          borderRadius: BorderRadius.circular(4),
                          rodStackItems: typeCounts.entries.map((entry) {
                            final startY = currentY;
                            currentY += entry.value;
                            return BarChartRodStackItem(
                              startY, 
                              currentY, 
                              entry.key.getColorScheme(colorScheme),
                            );
                          }).toList(),
                        ),
                      ],
                    );
                  }),
                  gridData: FlGridData(show: true, drawVerticalLine: false),
                  borderData: FlBorderData(show: false),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: true, interval: 1, reservedSize: 28),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (val, meta) => Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            DateFormat('E').format(last7Days[val.toInt()]), 
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ),
                      ),
                    ),
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  barTouchData: BarTouchData(
                    touchTooltipData: BarTouchTooltipData(
                      getTooltipColor: (group) => colorScheme.secondaryContainer,
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        return BarTooltipItem(
                          rod.toY.toInt().toString(),
                          TextStyle(
                            color: colorScheme.onSecondaryContainer,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
            if (usedTypes.isNotEmpty) ...[
              const SizedBox(height: 20),
              _buildLegend(context, usedTypes, colorScheme, l10n),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildLegend(
    BuildContext context, 
    List<SanitaryProducts> types, 
    ColorScheme colorScheme, 
    AppLocalizations l10n
  ) {
    return Wrap(
      spacing: 16,
      runSpacing: 8,
      children: types.map((type) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12, 
              height: 12, 
              decoration: BoxDecoration(
                color: type.getColorScheme(colorScheme), 
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 6),
            Text(
              type.getDisplayName(l10n), 
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        );
      }).toList(),
    );
  }
}