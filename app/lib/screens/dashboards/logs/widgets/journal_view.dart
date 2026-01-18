import 'package:flutter/material.dart';
import 'package:menstrudel/models/flows/flow_enum.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_clean_calendar/controllers/clean_calendar_controller.dart';
import 'package:scrollable_clean_calendar/scrollable_clean_calendar.dart';
import 'package:scrollable_clean_calendar/utils/enums.dart';
import 'package:menstrudel/l10n/app_localizations.dart';
import 'package:menstrudel/services/log_service.dart';
import 'package:menstrudel/services/period_service.dart';
import 'package:menstrudel/services/settings_service.dart';
import 'package:menstrudel/models/period_logs/log_day.dart';
import 'package:menstrudel/models/prefrences/day_of_week_enum.dart';

class PeriodJournalView extends StatefulWidget {
  final Function(DateTime) onLogRequested;
  final Function(LogDay) onLogTapped;

  const PeriodJournalView({
    super.key,
    required this.onLogRequested,
    required this.onLogTapped,
  });

  @override
  State<PeriodJournalView> createState() => _PeriodJournalViewState();
}

class _PeriodJournalViewState extends State<PeriodJournalView> {
  CleanCalendarController? _calendarController;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final periodService = context.watch<PeriodService>();
    final logService = context.watch<LogService>();
    final settingsService = context.watch<SettingsService>();

    if (periodService.isLoading || logService.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final earliestLogDate = logService.earliestLogDate;
    if (earliestLogDate == null) {
      return Center(child: Text(l10n.journalViewWidget_logYourFirstPeriod));
    }

    final logMap = logService.logMap;
    final predictionResult = periodService.predictionResult;
    final colorScheme = Theme.of(context).colorScheme;

    _calendarController ??= CleanCalendarController(
      minDate: earliestLogDate.subtract(const Duration(days: 365)),
      maxDate: DateTime.now().add(const Duration(days: 365)),
      initialFocusDate: DateTime.now(),
      weekdayStart: DayOfWeek.fromString(settingsService.startingDayOfWeek).toTableCalendar
    );

    return ScrollableCleanCalendar(
      calendarController: _calendarController!,
      layout: Layout.BEAUTY,
      locale: AppLocalizations.of(context)!.localeName,
      dayBuilder: (context, values) {
        final day = values.day;
        final dayOnly = DateUtils.dateOnly(day);
        final log = logMap[dayOnly];

        if (log != null) {
          return GestureDetector(
            onTap: () => widget.onLogTapped(log),
            child: Container(
              decoration: BoxDecoration(color: log.flow.color, shape: BoxShape.circle),
              alignment: Alignment.center,
              child: Text('${day.day}', style: TextStyle(color: colorScheme.onPrimary)),
            ),
          );
        }

        bool isPredictedDay = false;
        if (predictionResult?.estimatedStartDate != null && predictionResult?.estimatedEndDate != null) {
          final startOnly = DateUtils.dateOnly(predictionResult!.estimatedStartDate!);
          final endOnly = DateUtils.dateOnly(predictionResult!.estimatedEndDate!);
          isPredictedDay = !dayOnly.isBefore(startOnly) && !dayOnly.isAfter(endOnly);
        }

        if (isPredictedDay) {
          return GestureDetector(
            onTap: () => widget.onLogRequested(day),
            child: Container(
              decoration: BoxDecoration(
                color: colorScheme.error.withValues(alpha: 0.4),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Text('${day.day}', style: TextStyle(color: colorScheme.error, fontWeight: FontWeight.bold)),
            ),
          );
        }

        final isToday = DateUtils.isSameDay(day, DateTime.now());
        return GestureDetector(
          onTap: () => day.isAfter(DateTime.now()) ? null : widget.onLogRequested(day),
          child: Container(
            alignment: Alignment.center,
            decoration: isToday ? BoxDecoration(
              border: Border.all(color: colorScheme.primary, width: 2),
              shape: BoxShape.circle,
            ) : null,
            child: Text(
              '${day.day}',
              style: TextStyle(
                color: day.isAfter(DateTime.now()) 
                    ? colorScheme.onSurface.withAlpha(75) 
                    : colorScheme.onSurface,
              ),
            ),
          ),
        );
      },
    );
  }
}