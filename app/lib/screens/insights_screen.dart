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
  final PageController _cycleAndPeriodCarouselPageController = PageController(viewportFraction: 1.0);
  final PageController _painAndFlowCarouselPageController = PageController(viewportFraction: 1.0);
  int _cycleAndPeriodCarouselCurrentPage = 0;
  int _painAndFlowCarouselCurrentPage = 0;


  @override
  void initState() {
    super.initState();
    _loadInsightsData();

    _cycleAndPeriodCarouselPageController.addListener(() {
      final page = _cycleAndPeriodCarouselPageController.page?.round() ?? 0;
      if (page != _cycleAndPeriodCarouselCurrentPage) {
        setState(() {
          _cycleAndPeriodCarouselCurrentPage = page;
        });
      }
    });
    _painAndFlowCarouselPageController.addListener(() {
      final page = _painAndFlowCarouselPageController.page?.round() ?? 0;
      if (page != _painAndFlowCarouselCurrentPage) {
        setState(() {
          _painAndFlowCarouselCurrentPage = page;
        });
      }
    });
  }

  @override
  void dispose() {
    _cycleAndPeriodCarouselPageController.dispose();
    _painAndFlowCarouselPageController.dispose();
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

          final List<Widget> cycleAndPeriodCarouselItems = [
            CycleLengthVarianceWidget(periods: allPeriods),
            PeriodDurationWidget(periods: allPeriods),
          ];
          
          final List<Widget> painAndFlowCarouselItems = [
            PainBreakdownWidget(logs: allLogs),
            FlowBreakdownWidget(logs: allLogs),
          ];

          return ListView(
            padding: EdgeInsets.zero,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: SymptomFrequencyWidget(symptomCounts: symptomCounts),
              ),
              
              // --- First Carousel (Cycles/Periods) ---
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Column(
                  children: [
                    SizedBox(
                      height: 450.0,
                      child: PageView.builder(
                        controller: _cycleAndPeriodCarouselPageController,
                        itemCount: cycleAndPeriodCarouselItems.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                            ),
                            child: cycleAndPeriodCarouselItems[index],
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 12.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(cycleAndPeriodCarouselItems.length, (index) {
                        final isSelected = index == _cycleAndPeriodCarouselCurrentPage;
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
              
              // --- Second Carousel (Pain/Flow) ---
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Column(
                  children: [
                    SizedBox(
                      height: 350.0,
                      child: PageView.builder(
                        controller: _painAndFlowCarouselPageController,
                        itemCount: painAndFlowCarouselItems.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                            ),
                            child: painAndFlowCarouselItems[index],
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 12.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(painAndFlowCarouselItems.length, (index) {
                        final isSelected = index == _painAndFlowCarouselCurrentPage;
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