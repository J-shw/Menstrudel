import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:menstrudel/models/sex/sex_log_entry.dart';
import 'package:menstrudel/l10n/app_localizations.dart';
import 'package:menstrudel/models/sex/sex_type_enum.dart';

class SexActivityChart extends StatelessWidget {
  final List<SexLogEntry> historyEntries;

  const SexActivityChart({super.key, required this.historyEntries});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final last7Days = List.generate(
      7,
      (i) => today.subtract(Duration(days: 6 - i)),
    );
    final sevenDaysAgo = last7Days.first;
    final Map<String, List<SexLogEntry>> groupedEntries = {};
    final Set<SexTypes?> usedTypesSet = {};

    for (var entry in historyEntries) {
      if (entry.dateTime.isBefore(sevenDaysAgo)) continue;

      final dayKey = DateFormat('yyyy-MM-dd').format(entry.dateTime);
      groupedEntries.putIfAbsent(dayKey, () => []).add(entry);
      usedTypesSet.add(entry.sexType);
    }

    final usedTypes = usedTypesSet.toList();

    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.sexActivityScreen_activityTrend,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            AspectRatio(
              aspectRatio: 1.7,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  barGroups: List.generate(7, (index) {
                    final dayKey = DateFormat('yyyy-MM-dd').format(last7Days[index]);
                    final dayEntries = groupedEntries[dayKey] ?? [];
                    final typeCounts = <SexTypes?, int>{};
                    for (var e in dayEntries) {
                      typeCounts[e.sexType] = (typeCounts[e.sexType] ?? 0) + 1;
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
                            
                            final color = entry.key?.getColorScheme(colorScheme) 
                                          ?? colorScheme.outlineVariant;

                            return BarChartRodStackItem(startY, currentY, color);
                          }).toList(),
                        ),
                      ],
                    );
                  }),
                  gridData: const FlGridData(show: true, drawVerticalLine: false),
                  borderData: FlBorderData(show: false),
                  titlesData: FlTitlesData(
                    leftTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: true, interval: 1, reservedSize: 28),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (val, meta) {
                          if (val < 0 || val >= last7Days.length) return const SizedBox();
                          return Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              DateFormat('E').format(last7Days[val.toInt()]),
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          );
                        },
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
    List<SexTypes?> types,
    ColorScheme colorScheme,
    AppLocalizations l10n,
  ) {
    return Wrap(
      spacing: 16,
      runSpacing: 8,
      children: types.map((type) {
        final color = type?.getColorScheme(colorScheme) ?? colorScheme.outlineVariant;
        final label = type?.getDisplayName(l10n) ?? l10n.unknown;

        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
            const SizedBox(width: 6),
            Text(label, style: Theme.of(context).textTheme.bodySmall),
          ],
        );
      }).toList(),
    );
  }
}