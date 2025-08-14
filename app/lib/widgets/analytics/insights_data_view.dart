import 'package:flutter/material.dart';
import 'package:menstrudel/widgets/analytics/monthly_cycle_list_view.dart';
import 'package:menstrudel/widgets/analytics/cycle_flow_pill_view.dart';
import 'package:menstrudel/widgets/analytics/stat_card.dart';
import 'package:menstrudel/models/cycles/cycle_stats.dart';
import 'package:menstrudel/models/cycles/monthly_cycle_data.dart';
import 'package:menstrudel/models/periods/period_stats.dart';
import 'package:menstrudel/models/flows/flow_data.dart';

enum CycleView { 
  list, 
  flow 
}

class InsightsDataView extends StatefulWidget {
  final CycleStats cycleStats;
  final PeriodStats periodStats;
  final List<DailyFlowData> cycleFlowData;
  final List<MonthlyCycleData> monthlyCycleData;

  const InsightsDataView({
    super.key,
    required this.cycleStats,
    required this.periodStats,
    required this.monthlyCycleData,
    required this.cycleFlowData,
  });

  @override
  State<InsightsDataView> createState() => _InsightsDataViewState();
}

class _InsightsDataViewState extends State<InsightsDataView> {
  final _pageController = PageController();
  int _currentPage = 0;
  CycleView _currentView = CycleView.list;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
  
  Widget _buildIndicator(int index) {
    return Container(
      width: 8.0,
      height: 8.0,
      margin: const EdgeInsets.symmetric(horizontal: 4.0),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: _currentPage == index ? Theme.of(context).primaryColor : Colors.grey.withOpacity(0.5),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    List<Widget> statCards = [
      StatCard(
        icon: Icons.calendar_month,
        title: 'Average Cycle Length',
        value: '${widget.cycleStats.averageCycleLength} days',
      ),
      StatCard(
        icon: Icons.calendar_month,
        title: 'Average Period Length',
        value: '${widget.periodStats.averageLength} days',
      ),
      StatCard(
        icon: Icons.compress,
        title: 'Shortest Cycle',
        value: '${widget.cycleStats.shortestCycleLength ?? "N/A"} days',
      ),
      StatCard(
        icon: Icons.expand,
        title: 'Longest Cycle',
        value: '${widget.cycleStats.longestCycleLength ?? "N/A"} days',
      ),
      StatCard(
        icon: Icons.compress,
        title: 'Shortest Period',
        value: '${widget.periodStats.shortestLength ?? "N/A"} days',
      ),
      StatCard(
        icon: Icons.expand,
        title: 'Longest Period',
        value: '${widget.periodStats.longestLength ?? "N/A"} days',
      ),
      StatCard(
        icon: Icons.history,
        title: 'Cycles Analysed',
        value: '${widget.cycleStats.numberOfCycles}',
      ),
      StatCard(
        icon: Icons.history,
        title: 'Total Periods',
        value: '${widget.periodStats.numberofPeriods}',
      ),
    ];

    return Column(
      children: [
        SizedBox(
          height: 100,
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() => _currentPage = index);
            },
            itemCount: (statCards.length / 2).ceil(),
            itemBuilder: (context, index) {
              final int firstCardIndex = index * 2;
              final int secondCardIndex = firstCardIndex + 1;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Row(
                  children: <Widget>[
                    if (firstCardIndex < statCards.length)
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

        const SizedBox(height: 10),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate((statCards.length / 2).ceil(), (i) => _buildIndicator(i)),
        ),

        const SizedBox(height: 10),

        ToggleButtons(
          isSelected: [
            _currentView == CycleView.list,
            _currentView == CycleView.flow,
          ],
          onPressed: (int index) {
            setState(() {
              _currentView = CycleView.values[index];
            });
          },
          borderRadius: BorderRadius.circular(8.0),
          children: const [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text('Cycle Length'),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text('Flow Rate'),
            ),
          ],
        ),
        const SizedBox(height: 10),

        if (_currentView == CycleView.list)
          MonthlyCycleListView(
            monthlyCycleData: widget.monthlyCycleData,
          )
        else
         CycleFlowPillView(
            cycleFlowData: widget.cycleFlowData,
          ),
      ],
    );
  }
}