import 'package:flutter/material.dart';
import 'package:menstrudel/models/cycle_phase/cycle_phase_enum.dart';
import 'package:menstrudel/models/flows/flow_enum.dart';
import 'package:menstrudel/models/period_logs/pain_level_enum.dart';
import 'package:menstrudel/models/period_prediction_result.dart';
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
  void didChangeDependencies() {
    super.didChangeDependencies();
    _initCalendar();
  }

  void _initCalendar() {
    if (_calendarController != null) return;

    final logService = context.read<LogService>();
    final settingsService = context.read<SettingsService>();
    final earliest = logService.earliestLogDate;

    if (earliest != null) {
      _calendarController = CleanCalendarController(
        minDate: earliest.subtract(const Duration(days: 90)),
        maxDate: DateTime.now().add(const Duration(days: 90)),
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

  Set<DateTime> _calculatePredictedDates(PeriodService periodService) {
    final dates = <DateTime>{};
    final today = DateUtils.dateOnly(DateTime.now());
    
    void addRange(PeriodPredictionResult? prediction) {
      if (prediction?.estimatedStartDate != null &&
          prediction?.estimatedEndDate != null) {
        DateTime current = DateUtils.dateOnly(prediction!.estimatedStartDate);
        final end = DateUtils.dateOnly(prediction.estimatedEndDate);

        while (!current.isAfter(end)) {
          if (current.isAfter(today)) {
            dates.add(current);
          }
          current = current.add(const Duration(days: 1));
        }
      }
    }

    addRange(periodService.upcomingPeriodPrediction);
    addRange(periodService.followingPeriodPrediction);

    return dates;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final settingsService = context.read<SettingsService>();
    final colorScheme = Theme.of(context).colorScheme;
    final logService = context.watch<LogService>();
    final periodService = context.watch<PeriodService>();
    final logMap = logService.logMap;
    final predictedDates = _calculatePredictedDates(periodService);
    final predictedCurrentCycle = periodService.predictedCurrentCycle;
    
    final isLoading = logService.isLoading || periodService.isLoading;
    final futureColor = colorScheme.onSurface.withAlpha(75);
    final normalColor = colorScheme.onSurface;
    final now = DateTime.now();
    final todayMs = DateUtils.dateOnly(now).millisecondsSinceEpoch;

    if (_calendarController == null && !isLoading) {
      _initCalendar();
    }

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
        final now = DateTime.now();
        final todayOnly = DateUtils.dateOnly(now);
        final isToday = dayMs == todayMs;
        var phase = CyclePhase.unknown;

        if (predictedCurrentCycle != null) {
          phase = predictedCurrentCycle.getPhaseForDate(dayOnly);
        }

        if (logMap.containsKey(dayOnly)) {
          return _buildLogDay(day, logMap[dayOnly]!, colorScheme, isToday);
        }
        
        if (dayOnly.isAfter(todayOnly) && settingsService.isNaturalCycle) {
          if (settingsService.arePhasePredictionsEnabled && settingsService.displayFertileWindowOnCalendar && (phase == CyclePhase.fertileWindow || phase == CyclePhase.ovulation)) {
            return _buildPhaseDay(day, phase, colorScheme);
          }
          
          if (phase == CyclePhase.menstruation) {
              return _buildPredictedDay(day, colorScheme);
          }
          
        }

        if (predictedDates.contains(dayOnly) && !isToday) {
          return _buildPredictedDay(day, colorScheme);
        }

        return _buildDefaultDay(
          day: day,
          isToday: isToday,
          isFuture: dayMs > todayMs,
          colorScheme: colorScheme,
          normalColor: normalColor,
          futureColor: futureColor,
          phase: phase,
        );
      },
    );
  }

  Widget _buildLogDay(DateTime day, LogDay log, ColorScheme colorScheme, bool isToday) {
    final hasSymptoms = log.symptoms.isNotEmpty;
    final hasPain = log.painLevel != null;

    final symptomColor = Colors.teal.shade200;

    return GestureDetector(
      onTap: () => widget.onLogTapped(log),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 40,
            width: 40,
            margin: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: log.flow.color,
              shape: BoxShape.circle,
              border: isToday ? Border.all(color: colorScheme.primary, width: 3) : null,
            ),
            alignment: Alignment.center,
            child: Text(
              '${day.day}',
              style: TextStyle(
                color: colorScheme.onPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(
            height: 12,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (hasPain) 
                  Icon(
                    PainLevel.values[log.painLevel!].icon,
                    size: 10, 
                    color: PainLevel.values[log.painLevel!].color
                  ),
                if (hasPain && hasSymptoms) const SizedBox(width: 2),
                if (hasSymptoms) 
                  Icon(
                    Icons.add_circle,
                    size: 10, 
                    color: symptomColor
                  ),
              ],
            ),
          ),
        ],
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

  Widget _buildPhaseDay(DateTime day, CyclePhase phase, ColorScheme colorScheme) {
    final isOvulation = phase == CyclePhase.ovulation;

    return GestureDetector(
      onTap: () => widget.onLogRequested(day),
      child: Container(
        margin: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: phase.color,
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: Text(
          '${day.day}',
          style: TextStyle(
            color: isOvulation ? Colors.teal.shade900 : Colors.teal.shade700, // Not an issue for now as teal is the only colour used. But this needs sorting...
            fontWeight: isOvulation ? FontWeight.bold : FontWeight.normal,
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
    required CyclePhase phase,
  }) {
    return Container(
      margin: const EdgeInsets.all(4),
      alignment: Alignment.center,
      decoration: isToday
          ? BoxDecoration(
              border: phase==CyclePhase.fertileWindow || phase==CyclePhase.ovulation || phase==CyclePhase.menstruation || phase==CyclePhase.late
                 ? Border.all(color: phase.color, width: 3)
                 : Border.all(color: colorScheme.primary, width: 2),
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