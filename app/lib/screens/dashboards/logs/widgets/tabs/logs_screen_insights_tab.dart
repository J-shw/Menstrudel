import 'package:flutter/material.dart';
import 'package:menstrudel/models/cycles/cycle_stats.dart';
import 'package:menstrudel/models/period_logs/log_day.dart';
import 'package:menstrudel/models/period_logs/symptom.dart';
import 'package:menstrudel/models/periods/period.dart';
import 'package:menstrudel/models/flows/flow_data.dart';
import 'package:menstrudel/models/periods/period_stats.dart';
import 'package:menstrudel/services/log_service.dart';
import 'package:menstrudel/services/period_service.dart';
import 'package:menstrudel/utils/period_predictor.dart';
import 'package:menstrudel/widgets/insights/symptom_frequency.dart';
import 'package:menstrudel/widgets/insights/cycle_length_variance.dart';
import 'package:menstrudel/widgets/insights/period_duration.dart';
import 'package:menstrudel/widgets/insights/flow_intensity.dart';
import 'package:menstrudel/widgets/insights/pain_intensity.dart';
import 'package:menstrudel/widgets/insights/log_summary_widget.dart';
import 'package:menstrudel/widgets/insights/monthly_flow.dart';

import 'package:menstrudel/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class LogsScreenInsightsTab extends StatefulWidget {
  const LogsScreenInsightsTab({super.key});

  @override
  State<LogsScreenInsightsTab> createState() => _LogsScreenInsightsTab();
}

class _LogsScreenInsightsTab extends State<LogsScreenInsightsTab> {
  late Future<List<dynamic>> _insightsDataFuture;
  final PageController _cycleAndPeriodCarouselPageController = PageController(viewportFraction: 1.0);
  final PageController _painAndFlowCarouselPageController = PageController(viewportFraction: 1.0);
  int _cycleAndPeriodCarouselCurrentPage = 0;
  int _painAndFlowCarouselCurrentPage = 0;
  int _selectedMonths = 6;

  late PeriodService periodService = context.read<PeriodService>();
  late LogService logsService = context.read<LogService>();

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

  DateTime get _insightsDataStartDate => 
      DateTime.now().subtract(Duration(days: _selectedMonths * 30));

  @override
  void dispose() {
    _cycleAndPeriodCarouselPageController.dispose();
    _painAndFlowCarouselPageController.dispose();
    super.dispose();
  }

  void _loadInsightsData() {
    _insightsDataFuture = Future.wait([
      periodService.getPeriodsSince(_insightsDataStartDate),
      logsService.getLogsSince(_insightsDataStartDate),
      periodService.getMonthlyPeriodFlowsSince(_insightsDataStartDate),
      logsService.getSymptomFrequencySince(_insightsDataStartDate),
    ]);
  }

  String _formatLoggingSpan(List<LogDay> allLogs, AppLocalizations l10n) {
    if (allLogs.isEmpty) {
      return l10n.dayCount(0);
    }

    allLogs.sort((a, b) => (a.date).compareTo(b.date));
    final DateTime firstDate = allLogs.first.date;
    final DateTime lastDate = allLogs.last.date;
    final int totalDays = lastDate.difference(firstDate).inDays;

    if (totalDays == 0) {
      return l10n.dayCount(1);
    }

    final int years = totalDays ~/ 365;
    final int remainingDaysAfterYears = totalDays % 365;
    final int months = remainingDaysAfterYears ~/ 30;

    List<String> parts = [];
    
    if (years > 0) {
      parts.add(l10n.yearCount(years));
    } 
    if (months > 0) {
      parts.add(l10n.monthCount(months));
    }

    if (parts.isEmpty) {
      return l10n.dayCount(totalDays); 
    }

    return parts.join(', ');
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return FutureBuilder<List<dynamic>>(
      future: _insightsDataFuture,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final allPeriods = snapshot.data![0] as List<Period>;
          final allLogs = snapshot.data![1] as List<LogDay>;
          final allFlows = snapshot.data![2] as List<MonthlyFlowData>;
          final symptomCounts = snapshot.data![3] as Map<Symptom, int>;
          final CycleStats? cycleStats = PeriodPredictor.getCycleStats(allPeriods);
          final PeriodStats? periodStats = PeriodPredictor.getPeriodStats(allPeriods);

          final String loggingSpan = _formatLoggingSpan(allLogs, l10n);

          final List<Widget> cycleAndPeriodCarouselItems = [
            CycleLengthVarianceWidget(periods: allPeriods,  cycleStats: cycleStats),
            PeriodDurationWidget(periods: allPeriods, periodStats: periodStats),
          ];
          
          final List<Widget> painAndFlowCarouselItems = [
            PainBreakdownWidget(logs: allLogs),
            FlowBreakdownWidget(logs: allLogs),
          ];

          return Padding(
            padding: const EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                LogSummaryWidget(
                  totalLoggedDays: allLogs.length,
                  loggingSpan: loggingSpan,
                ),

                const SizedBox(height: 16.0),

                SegmentedButton<int>(
                  segments: [
                    ButtonSegment(value: 6, label: Text(l10n.monthCount(6))),
                    ButtonSegment(value: 12, label: Text(l10n.monthCount(12))),
                  ],
                  selected: {_selectedMonths},
                  onSelectionChanged: (Set<int> newSelection) {
                    setState(() {
                      _selectedMonths = newSelection.first;
                      _loadInsightsData();
                    });
                  },
                ),
                
                const SizedBox(height: 16.0),

                SymptomFrequencyWidget(symptomCounts: symptomCounts),

                const SizedBox(height: 16.0),
                
                // --- First Carousel (Cycles/Periods) ---
                Column(
                  children: [
                    SizedBox(
                      height: 450.0,
                      child: PageView.builder(
                        controller: _cycleAndPeriodCarouselPageController,
                        itemCount: cycleAndPeriodCarouselItems.length,
                        itemBuilder: (context, index) {
                          return cycleAndPeriodCarouselItems[index];
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

                const SizedBox(height: 16.0),
                
                // --- Second Carousel (Pain/Flow) ---
                Column(
                  children: [
                    SizedBox(
                      height: 350.0,
                      child: PageView.builder(
                        controller: _painAndFlowCarouselPageController,
                        itemCount: painAndFlowCarouselItems.length,
                        itemBuilder: (context, index) {
                          return painAndFlowCarouselItems[index];
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
                
                const SizedBox(height: 16.0),

                FlowPatternsWidget(monthlyFlowData: allFlows),
              ],
            ),
          );
        }
        
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(
            child: Text('${l10n.insightsScreen_errorPrefix} ${snapshot.error}'),
          );
        }
        
        return Center(child: Text(l10n.insightsScreen_noDataAvailable));
      },
    );
  }
}