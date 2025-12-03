import 'package:flutter/material.dart';
import 'package:menstrudel/database/repositories/periods_repository.dart';
import 'package:menstrudel/models/period_logs/period_day.dart';
import 'package:menstrudel/models/period_logs/symptom.dart';
import 'package:menstrudel/models/periods/period.dart';
import 'package:menstrudel/models/flows/flow_data.dart';

import 'package:menstrudel/widgets/insights/symptom_frequency.dart';
import 'package:menstrudel/widgets/insights/cycle_length_variance.dart';
import 'package:menstrudel/widgets/insights/period_duration.dart';
import 'package:menstrudel/widgets/insights/flow_intensity.dart';
import 'package:menstrudel/widgets/insights/pain_intensity.dart';
import 'package:menstrudel/widgets/insights/year_heat_map.dart';
import 'package:menstrudel/widgets/insights/monthly_flow.dart';

import 'package:menstrudel/l10n/app_localizations.dart';

class InsightsScreen extends StatefulWidget {
  const InsightsScreen({super.key});

  @override
  State<InsightsScreen> createState() => _InsightsScreenState();
}

class _InsightsScreenState extends State<InsightsScreen> {
  late Future<List<dynamic>> _insightsDataFuture;
  final periodsRepo = PeriodsRepository();
  final PageController _pageController = PageController(viewportFraction: 1.0);
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _loadInsightsData();

    _pageController.addListener(() {
      final page = _pageController.page?.round() ?? 0;
      if (page != _currentPage) {
        setState(() {
          _currentPage = page;
        });
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _loadInsightsData() {
    _insightsDataFuture = Future.wait([
      periodsRepo.readAllPeriods(),
      periodsRepo.readAllPeriodLogs(),
      periodsRepo.getMonthlyPeriodFlows(),
      periodsRepo.getSymptomFrequency(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    const double carouselHeight = 450.0;

    return FutureBuilder<List<dynamic>>(
      future: _insightsDataFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(
            child: Text('${l10n.insightsScreen_errorPrefix} ${snapshot.error}'),
          );
        }

        if (snapshot.hasData) {
          final allPeriods = snapshot.data![0] as List<Period>;
          final allLogs = snapshot.data![1] as List<PeriodDay>;
          final allFlows = snapshot.data![2] as List<MonthlyFlowData>;
          final symptomCounts = snapshot.data![3] as Map<Symptom, int>;

          final List<Widget> carouselItems = [
            CycleLengthVarianceWidget(periods: allPeriods),
            PeriodDurationWidget(periods: allPeriods),
          ];

          return ListView(
            padding: EdgeInsets.zero,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: SymptomFrequencyWidget(symptomCounts: symptomCounts),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Column(
                  children: [
                    SizedBox(
                      height: carouselHeight,
                      child: PageView.builder(
                        controller: _pageController,
                        itemCount: carouselItems.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                            ),
                            child: carouselItems[index],
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 12.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(carouselItems.length, (index) {
                        final isSelected = index == _currentPage;
                        return Container(
                          width: isSelected ? 8.0 : 6.0,
                          height: isSelected ? 8.0 : 6.0,
                          margin: const EdgeInsets.symmetric(horizontal: 4.0),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isSelected
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(
                                    context,
                                  ).colorScheme.onSurface.withValues(alpha: 0.3),
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: PainBreakdownWidget(logs: allLogs),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: FlowBreakdownWidget(logs: allLogs),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: FlowPatternsWidget(monthlyFlowData: allFlows),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: YearHeatmapWidget(logs: allLogs),
              ),
            ],
          );
        }
        return Center(child: Text(l10n.insightsScreen_noDataAvailable));
      },
    );
  }
}