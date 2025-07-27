import 'package:flutter/material.dart';
import 'package:menstrudel/models/cycle_stats.dart';

class AnalyticsScreen extends StatelessWidget {
final CycleStats? cycleStats; 

const AnalyticsScreen({super.key, this.cycleStats}); 

@override
Widget build(BuildContext context) {
	final ColorScheme colorScheme = Theme.of(context).colorScheme;

	return Scaffold(
		appBar: AppBar(
			title: const Text('Analytics View'),
		),
		body: Center(
			child: Padding(
			padding: const EdgeInsets.all(16.0),
			child: Column(
				mainAxisAlignment: MainAxisAlignment.center,
				crossAxisAlignment: CrossAxisAlignment.start,
				children: [
				Text(
					'Cycle Statistics:',
					style: TextStyle(
					fontSize: 24,
					fontWeight: FontWeight.bold,
					color: colorScheme.primary,
					),
				),
				const SizedBox(height: 20),
				if (cycleStats == null) 
					Text(
					'No sufficient data for analytics yet.\nLog at least two periods for stats.',
					textAlign: TextAlign.center,
					style: TextStyle(
						fontSize: 16,
						color: colorScheme.onSurfaceVariant,
					),
					)
				else 
					Column(
					crossAxisAlignment: CrossAxisAlignment.start,
					children: [
						Text(
							'Average Cycle Length: ${cycleStats!.averageCycleLength} days',
							style: TextStyle(fontSize: 18, color: colorScheme.onSurface),
						),
						const SizedBox(height: 8),
						Text(
							'Shortest Cycle: ${cycleStats!.shortestCycleLength ?? "N/A"} days',
							style: TextStyle(fontSize: 18, color: colorScheme.onSurface),
						),
						const SizedBox(height: 8),
						Text(
							'Longest Cycle: ${cycleStats!.longestCycleLength ?? "N/A"} days',
							style: TextStyle(fontSize: 18, color: colorScheme.onSurface),
						),
						const SizedBox(height: 8),
						Text(
							'Number of Cycles Processed: ${cycleStats!.numberOfCycles}',
							style: TextStyle(fontSize: 18, color: colorScheme.onSurface),
						),
					],
					),
				],
			),
			),
		),
		);
	}
}