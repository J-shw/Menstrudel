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
  Set<DateTime> _predictedDates = {};

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _initCalendar();
    _precomputePredictions();
  }

  void _initCalendar() {
    final logService = context.read<LogService>();
    final settingsService = context.read<SettingsService>();
    final earliest = logService.earliestLogDate;

    if (earliest != null && _calendarController == null) {
      _calendarController = CleanCalendarController(
        minDate: earliest.subtract(const Duration(days: 90)),
        maxDate: DateTime.now().add(const Duration(days: 60)),
        initialFocusDate: DateTime.now(),
        weekdayStart: DayOfWeek.fromString(
          settingsService.startingDayOfWeek,
        ).toTableCalendar,
        onDayTapped: (date) {
          widget.onLogRequested(date);
        },
      );
    }
  }

  void _precomputePredictions() {
    final periodService = context.read<PeriodService>();
    final prediction = periodService.predictionResult;

    if (prediction?.estimatedStartDate != null &&
        prediction?.estimatedEndDate != null) {
      final start = DateUtils.dateOnly(prediction!.estimatedStartDate);
      final end = DateUtils.dateOnly(prediction.estimatedEndDate);

      final dates = <DateTime>{};
      DateTime current = start;
      while (!current.isAfter(end)) {
        dates.add(current);
        current = current.add(const Duration(days: 1));
      }

      if (dates.length != _predictedDates.length) {
        setState(() => _predictedDates = dates);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final futureColor = colorScheme.onSurface.withAlpha(75);
    final normalColor = colorScheme.onSurface;
    final now = DateTime.now();
    final today = DateUtils.dateOnly(now);
    final todayMs = today.millisecondsSinceEpoch;
    final logMap = context.select((LogService s) => s.logMap);
    final isLoading =
        context.select((LogService s) => s.isLoading) ||
        context.select((PeriodService s) => s.isLoading);

    if (isLoading) return const Center(child: CircularProgressIndicator());
    if (_calendarController == null) {
      return Center(child: Text(l10n.journalViewWidget_logYourFirstPeriod));
    }

    return ScrollableCleanCalendar(
      calendarController: _calendarController!,
      layout: Layout.BEAUTY,
      locale: l10n.localeName,
      dayBuilder: (context, values) {
        final day = values.day;
        final dayMs = day.millisecondsSinceEpoch;
        final dayOnly = DateUtils.dateOnly(day);

        if (logMap.containsKey(dayOnly)) {
          return _buildLogDay(day, logMap[dayOnly]!, colorScheme);
        }

        if (_predictedDates.contains(dayOnly)) {
          return _buildPredictedDay(day, colorScheme);
        }

        return _buildDefaultDay(
          day: day,
          isToday: dayMs == todayMs,
          isFuture: dayMs > todayMs,
          colorScheme: colorScheme,
          normalColor: normalColor,
          futureColor: futureColor,
        );
      },
    );
  }

  Widget _buildLogDay(DateTime day, LogDay log, ColorScheme colorScheme) {
    return GestureDetector(
      onTap: () => widget.onLogTapped(log),
      child: Container(
        margin: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: log.flow.color,
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: Text(
          '${day.day}',
          style: TextStyle(color: colorScheme.onPrimary),
        ),
      ),
    );
  }

  Widget _buildPredictedDay(DateTime day, ColorScheme colorScheme) {
    return GestureDetector(
      onTap: () => widget.onLogRequested(day),
      child: Container(
        margin: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: colorScheme.error.withValues(alpha: 0.2),
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: Text(
          '${day.day}',
          style: TextStyle(
            color: colorScheme.error,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildDefaultDay({
    required DateTime day,
    required bool isToday,
    required bool isFuture,
    required ColorScheme colorScheme,
    required Color normalColor,
    required Color futureColor,
  }) {
    return Container(
      margin: const EdgeInsets.all(4),
      alignment: Alignment.center,
      decoration: isToday
          ? BoxDecoration(
              border: Border.all(color: colorScheme.primary, width: 2),
              shape: BoxShape.circle,
            )
          : null,
      child: Text(
        '${day.day}',
        style: TextStyle(color: isFuture ? futureColor : normalColor),
      ),
    );
  }
}
