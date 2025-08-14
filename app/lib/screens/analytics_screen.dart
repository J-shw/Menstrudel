import 'package:flutter/material.dart';
import 'package:menstrudel/models/cycles/cycle_stats.dart';
import 'package:menstrudel/models/cycles/monthly_cycle_data.dart';
import 'package:menstrudel/models/periods/period_stats.dart';
import 'package:menstrudel/utils/period_predictor.dart';
import 'package:menstrudel/database/period_database.dart';
import 'package:menstrudel/widgets/analytics/no_data_view.dart';
import 'package:menstrudel/widgets/analytics/insights_data_view.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
	List<MonthlyCycleData> _monthlyCycleData = [];
	CycleStats? _cycleStats;
  PeriodStats? _periodStats;

  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
	void initState() {
		super.initState();
		_refreshPeriodLogs();

    _pageController.addListener(() {
      int next = _pageController.page!.round();
      if (_currentPage != next) {
        setState(() {
          _currentPage = next;
        });
      }
    });
	}

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

	Future<void> _refreshPeriodLogs() async {
		final periodLogData = await PeriodDatabase.instance.readAllPeriodLogs();
    final periodData = await PeriodDatabase.instance.readAllPeriods();
		setState(() {
			_cycleStats = PeriodPredictor.getCycleStats(periodLogData);
			_monthlyCycleData = PeriodPredictor.getMonthlyCycleData(periodLogData);
      _periodStats = PeriodPredictor.getPeriodData(periodData);
		});
	}

	@override
	Widget build(BuildContext context) {

    if (_cycleStats == null) {
      return const NoDataView();
    }
    
    return InsightsDataView(
      cycleStats: _cycleStats!,
      periodStats: _periodStats!,
      monthlyCycleData: _monthlyCycleData,
    );
	}
}