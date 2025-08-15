import 'package:flutter/material.dart';
import 'package:menstrudel/database/period_database.dart';
import 'package:menstrudel/models/period_logs/period_logs.dart';
import 'package:menstrudel/models/periods/period.dart';

import 'package:menstrudel/widgets/insights/symptom_frequency.dart';
import 'package:menstrudel/widgets/insights/cycle_length_variance.dart';
import 'package:menstrudel/widgets/insights/flow_intensity.dart';
import 'package:menstrudel/widgets/insights/year_heat_map.dart';



class InsightsScreen extends StatefulWidget {
  const InsightsScreen({super.key});

  @override
  State<InsightsScreen> createState() => _InsightsScreenState();
}

class _InsightsScreenState extends State<InsightsScreen> {
  late Future<List<dynamic>> _insightsDataFuture;

  @override
  void initState() {
    super.initState();
    _loadInsightsData();
  }

  void _loadInsightsData() {
    final db = PeriodDatabase.instance;
    _insightsDataFuture = Future.wait([
      db.readAllPeriods(),
      db.readAllPeriodLogs(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: _insightsDataFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (snapshot.hasData) {
          final allPeriods = snapshot.data![0] as List<PeriodEntry>;
          final allLogs = snapshot.data![1] as List<PeriodLogEntry>;

          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              SymptomFrequencyWidget(logs: allLogs),

              CycleLengthVarianceWidget(periods: allPeriods),

              FlowBreakdownWidget(logs: allLogs),
              
              YearHeatmapWidget(logs: allLogs),
            ],
          );
        }
        return const Center(child: Text('No data available.'));
      },
      
    );
  }
}