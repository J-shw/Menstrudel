import 'package:flutter/material.dart';
import 'package:menstrudel/models/cycle_stats.dart';
import 'package:menstrudel/models/monthly_cycle_data.dart';
import 'package:menstrudel/models/period_stats.dart';
import 'package:menstrudel/widgets/monthly_cycle_list_view.dart';
import 'package:menstrudel/utils/period_predictor.dart';
import 'package:menstrudel/database/period_database.dart';
import 'package:menstrudel/widgets/navigation_bar.dart';
import 'package:menstrudel/widgets/app_bar.dart';
import 'package:intl/intl.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
	List<MonthlyCycleData> _monthlyCycleData = [];
	CycleStats? _cycleStats;
  PeriodStats? _periodStats;

  @override
	void initState() {
		super.initState();
		_refreshPeriodLogs();
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
		final ColorScheme colorScheme = Theme.of(context).colorScheme;

		Widget buildStatCard({
			required IconData icon,
			required String title,
			required String value,
			required ColorScheme colors,
			}) {
			return Column(
					mainAxisSize: MainAxisSize.min,
					mainAxisAlignment: MainAxisAlignment.center,
					children: [
						Text(
							title,
							style: TextStyle(
								fontSize: 14,
								fontWeight: FontWeight.normal,
								color: colors.onSurfaceVariant, 
							),
							overflow: TextOverflow.ellipsis,
						),
						const SizedBox(height: 5),
						Row(
							mainAxisSize: MainAxisSize.min,
							children: [
								Icon(
									icon,
									size: 18.0,
									color: colors.primary,
								),
								const SizedBox(width: 5),
								Text(
									value,
									style: TextStyle(
										fontSize: 16,
										fontWeight: FontWeight.bold,
										color: colors.onSurface,
									),
								),
							],
						),
					],
				
			);
		}

    final List<Widget> statCards = [
      buildStatCard(
        icon: Icons.calendar_month,
        title: 'Average Cycle Length',
        value: '${_cycleStats!.averageCycleLength} days',
        colors: colorScheme,
      ),
      buildStatCard(
        icon: Icons.calendar_month,
        title: 'Average Period Length',
        value: '${_periodStats!.averageLength} days',
        colors: colorScheme,
      ),
      buildStatCard(
        icon: Icons.compress,
        title: 'Shortest Cycle',
        value: '${_cycleStats!.shortestCycleLength ?? "N/A"} days',
        colors: colorScheme,
      ),
      buildStatCard(
        icon: Icons.expand,
        title: 'Longest Cycle',
        value: '${_cycleStats!.longestCycleLength ?? "N/A"} days',
        colors: colorScheme,
      ),
      buildStatCard(
        icon: Icons.compress,
        title: 'Shortest Period',
        value: '${_periodStats!.shortestLength ?? "N/A"} days',
        colors: colorScheme,
      ),
      buildStatCard(
        icon: Icons.expand,
        title: 'Longest Period',
        value: '${_periodStats!.longestLength ?? "N/A"} days',
        colors: colorScheme,
      ),
      buildStatCard(
        icon: Icons.history,
        title: 'Cycles Analysed',
        value: '${_cycleStats!.numberOfCycles}',
        colors: colorScheme,
      ),
      buildStatCard(
        icon: Icons.history,
        title: 'Total Periods',
        value: '${_periodStats!.numberofPeriods}',
        colors: colorScheme,
      ),
    ];
		
    return Scaffold(
      appBar: TopAppBar(
        titleText: "Analytics"
      ),
			body: _cycleStats == null
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
				: Center( 
					child: Column(
						children: [
							SizedBox(
                height: 200,
                child: PageView.builder(
                  itemCount: (statCards.length / 2).ceil(),
                  itemBuilder: (BuildContext context, int index) {
                    final int firstCardIndex = index * 2;
                    final int secondCardIndex = firstCardIndex + 1;

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Row(
                        children: <Widget>[
                          Expanded(child: statCards[firstCardIndex]),
                          if (secondCardIndex < statCards.length) ...[
                            const SizedBox(width: 10),
                            Expanded(child: statCards[secondCardIndex]),
                          ],
                        ],
                      ),
                    );
                  },
                ),
              ),
							
							Expanded( 
								child: MonthlyCycleListView(
									monthlyCycleData: _monthlyCycleData, // Pass the data to your chart component
								),
							),
						],
					),
				),
        bottomNavigationBar: MainBottomNavigationBar(isAnalyticsScreenActive: true,),
			);
	}
}