import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:menstrudel/models/monthly_cycle_data.dart';
import 'dart:math' as math;

class MonthlyCycleListView extends StatelessWidget {
	final List<MonthlyCycleData>? monthlyCycleData;

	const MonthlyCycleListView({
		super.key,
		this.monthlyCycleData,
	});

	@override
	Widget build(BuildContext context) {
		final ColorScheme colorScheme = Theme.of(context).colorScheme;

		final double screenWidth = MediaQuery.of(context).size.width;
		const double axisLabelWidth = 40.0;
		const double barHeight = 30.0;
		const double maxBarWidthPercentage = 0.65;

		const double minDataValue = 20; 
		const double maxDataValue = 45; 

		final double maxBarPixelWidth = screenWidth * maxBarWidthPercentage;

		double getScaledBarWidth(int cycleLength) {
			if (cycleLength <= minDataValue) return 5.0; 
			
			if (cycleLength >= maxDataValue) return maxBarPixelWidth;

			double scale = (cycleLength - minDataValue) / (maxDataValue - minDataValue);
			return scale * maxBarPixelWidth;
		}

		if (monthlyCycleData == null || monthlyCycleData!.isEmpty) {
		return Center(
			child: Text(
			'Not enough data for monthly cycle graph.',
			style: TextStyle(fontSize: 16, color: colorScheme.onSurfaceVariant),
			),
		);
		} else {
		return Expanded(
			child: Padding( 
			padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
			child: Column( 
				crossAxisAlignment: CrossAxisAlignment.start, 
				children: [
				
				Padding(
					padding: const EdgeInsets.only(bottom: 5.0),
					child: Text(
						'Monthly Cycle Lengths (Days)',
						style: TextStyle(
							fontSize: 18,
							fontWeight: FontWeight.bold,
							color: colorScheme.onSurface,
						),
					),
				),

				Expanded( 
					child: ListView.builder(
					shrinkWrap: true,
					itemCount: monthlyCycleData!.length,
					itemBuilder: (context, index) {
						final data = monthlyCycleData![index];
						final String monthName = DateFormat.MMM().format(DateTime(data.year, data.month));
						
						final double barWidth = getScaledBarWidth(data.cycleLength);

						return Container( 
							padding: const EdgeInsets.symmetric(vertical: 8.0), 
							height: barHeight + 15, 
							child: Row(
								crossAxisAlignment: CrossAxisAlignment.center,
								children: [
									SizedBox(
										width: axisLabelWidth,
										child: Stack(
										alignment: Alignment.center,
										children: [
											Text(
												monthName,
												style: TextStyle(
													fontSize: 12,
													fontWeight: FontWeight.bold,
													color: colorScheme.onSurface,
												),
											),
										],
										),
									),
									const SizedBox(width: 8),

									Align(
										alignment: Alignment.centerLeft,
										child: Container(
										width: barWidth,
										height: barHeight,
										decoration: BoxDecoration(
											color: Color.fromARGB(255, 255, 118, 118),
											borderRadius: BorderRadius.circular(barHeight / 2), 
										),
										child: Center(
											child: Text(
											'${data.cycleLength}',
											style: TextStyle(
												color: colorScheme.onSecondary,
												fontWeight: FontWeight.bold,
												fontSize: 14,
											),
											),
										),
										),
									),
								],
							),
						);
					},
					),
				),
				],
			),
			),
		);
		}
	}
}