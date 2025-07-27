import 'package:flutter/material.dart';
import 'package:menstrudel/models/cycle_stats.dart';

class AnalyticsScreen extends StatelessWidget {
  final CycleStats? cycleStats;

  const AnalyticsScreen({super.key, this.cycleStats});

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    Widget buildStatCard({
      required IconData icon,
      required String title,
      required String value,
      required ColorScheme colors,
    }) {
      return Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        elevation: 4.0,
        margin: const EdgeInsets.all(8.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 40.0,
                color: colors.primary,
              ),
              const SizedBox(height: 10),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: colors.onSurface,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                value,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: colors.secondary,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Analytics View'),
      ),
      body: cycleStats == null
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.info_outline,
                      size: 60,
                      color: colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Not enough data for analytics yet.\nLog at least two periods to see your cycle stats.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 10.0,
                children: <Widget>[
                  buildStatCard(
                    icon: Icons.calendar_month,
                    title: 'Average Cycle Length',
                    value: '${cycleStats!.averageCycleLength} days',
                    colors: colorScheme,
                  ),
                  buildStatCard(
                    icon: Icons.compress,
                    title: 'Shortest Cycle',
                    value: '${cycleStats!.shortestCycleLength ?? "N/A"} days',
                    colors: colorScheme,
                  ),
                  buildStatCard(
                    icon: Icons.expand,
                    title: 'Longest Cycle',
                    value: '${cycleStats!.longestCycleLength ?? "N/A"} days',
                    colors: colorScheme,
                  ),
                  buildStatCard(
                    icon: Icons.history,
                    title: 'Cycles Analyzed',
                    value: '${cycleStats!.numberOfCycles}',
                    colors: colorScheme,
                  ),
                ],
              ),
            ),
    );
  }
}