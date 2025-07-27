import 'package:flutter/material.dart';
import 'package:menstrudel/models/cycle_stats.dart';
import 'package:menstrudel/models/monthly_cycle_data.dart';
import 'package:menstrudel/widgets/monthly_cycle_list_view.dart';
import 'package:intl/intl.dart';

class AnalyticsScreen extends StatelessWidget {
	final CycleStats? cycleStats;
	final List<MonthlyCycleData>? monthlyCycleData;

  	const AnalyticsScreen({
		super.key, 
		this.cycleStats,
		this.monthlyCycleData,
	});

	@override
	Widget build(BuildContext context) {
		final ColorScheme colorScheme = Theme.of(context).colorScheme;

		Widget buildStatCard({
			required IconData icon,
			required String title,
			required String value,
			required ColorScheme colors,
			}) {
			return SizedBox(
				child: Padding(
					padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
					child: Column(
						mainAxisSize: MainAxisSize.min,
						mainAxisAlignment: MainAxisAlignment.center,
						crossAxisAlignment: CrossAxisAlignment.start,
						children: [
							Text(
								title,
								textAlign: TextAlign.left,
								style: TextStyle(
								fontSize: 14,
								fontWeight: FontWeight.normal,
								color: colors.onSurfaceVariant, 
								),
								overflow: TextOverflow.ellipsis,
							),
							const SizedBox(height: 4),
							Row(
								mainAxisSize: MainAxisSize.min,
								children: [
									Icon(
										icon,
										size: 18.0,
										color: colors.primary,
									),
									const SizedBox(width: 6),
									Text(
										value,
										textAlign: TextAlign.left,
										style: TextStyle(
										fontSize: 16,
										fontWeight: FontWeight.bold,
										color: colors.onSurface,
										),
									),
								],
							),
						],
					),
				),
			);
		}
		return Scaffold(
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
				: Center( 
					child: Column(
						children: [
								SizedBox(
									height: 300,
									child: GridView.count(
										crossAxisCount: 2,
										crossAxisSpacing: 10.0,
										mainAxisSpacing: 10.0,
										physics: const NeverScrollableScrollPhysics(),
										childAspectRatio: 2.5,
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
												title: 'Cycles Analysed',
												value: '${cycleStats!.numberOfCycles}',
												colors: colorScheme,
											),
										],
									),
								),
	
							Expanded( 
		
								child: MonthlyCycleListView(
									monthlyCycleData: monthlyCycleData, // Pass the data to your chart component
								),
							),
						],
					),
				),
			);
	}
}