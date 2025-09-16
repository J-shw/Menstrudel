import 'package:flutter_test/flutter_test.dart';
import 'package:menstrudel/database/app_database.dart';
import 'package:menstrudel/models/period_logs/flow_enum.dart';
import 'package:menstrudel/models/period_logs/period_day.dart';
import 'package:menstrudel/database/repositories/periods_repository.dart';
import 'package:menstrudel/utils/exceptions.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

PeriodDay _log(String date, {FlowRate flow = FlowRate.medium}) =>
    PeriodDay(date: DateTime.parse(date), flow: flow, symptoms: [], painLevel: 0);

void main() {
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  group('PeriodsRepository Tests', () {
    late PeriodsRepository repository;
    late AppDatabase dbProvider;

    setUp(() async {
      dbProvider = AppDatabase.instance;
      await dbProvider.init(inMemory: true);
      repository = PeriodsRepository();
    });

    tearDown(() async {
      await dbProvider.close();
    });

    // --- GROUP 1: Core CRUD Operations ---
    group('Core Log Operations (CRUD)', () {
      test('createPeriodLog should add a log and its corresponding period', () async {
        await repository.createPeriodLog(_log('2025-09-01'));

        final logs = await repository.readAllPeriodLogs();
        expect(logs.length, 1);
        expect(logs.first.date, DateTime.parse('2025-09-01'));

        final periods = await repository.readAllPeriods();
        expect(periods.length, 1);
        expect(periods.first.totalDays, 1);
      });

      test('updating a log flow should not affect period structure', () async {
        final logToUpdate = await repository.createPeriodLog(_log('2025-09-01', flow: FlowRate.medium));
        await repository.createPeriodLog(_log('2025-09-02'));

        final updatedLog = logToUpdate.copyWith(flow: FlowRate.heavy);
        await repository.updatePeriodLog(updatedLog);

        final periods = await repository.readAllPeriods();
        expect(periods.length, 1);
        expect(periods.first.totalDays, 2);

        final changedLog = await repository.readPeriodLog(logToUpdate.id!);
        expect(changedLog.flow, FlowRate.heavy.intValue);
      });

      test('deleting the only log should remove the period entirely', () async {
        final logToDelete = await repository.createPeriodLog(_log('2025-09-01'));

        await repository.deletePeriodLog(logToDelete.id!);

        final periods = await repository.readAllPeriods();
        final logs = await repository.readAllPeriodLogs();
        expect(periods, isEmpty);
        expect(logs, isEmpty);
      });
    });

    // --- GROUP 2: Period Recalculation Logic ---
    group('Period Recalculation Logic', () {
      test('creating consecutive logs should extend the existing period', () async {
        await repository.createPeriodLog(_log('2025-09-01'));
        await repository.createPeriodLog(_log('2025-09-02'));

        final periods = await repository.readAllPeriods();
        expect(periods.length, 1);
        expect(periods.first.totalDays, 2);
      });

      test('creating a log with a gap should result in a new period', () async {
        await repository.createPeriodLog(_log('2025-09-01'));
        await repository.createPeriodLog(_log('2025-09-05'));

        final periods = await repository.readAllPeriods();
        expect(periods.length, 2);
      });

      test('creating a log between two existing periods should merge them', () async {
        await repository.createPeriodLog(_log('2025-09-01'));
        await repository.createPeriodLog(_log('2025-09-03'));
        
        var periods = await repository.readAllPeriods();
        expect(periods.length, 2);

        await repository.createPeriodLog(_log('2025-09-02'));

        periods = await repository.readAllPeriods();
        expect(periods.length, 1);
        expect(periods.first.totalDays, 3);
      });

      test('adding a back-dated log should correctly extend an existing period backwards', () async {
        await repository.createPeriodLog(_log('2025-09-10'));
        await repository.createPeriodLog(_log('2025-09-09'));

        final periods = await repository.readAllPeriods();
        expect(periods.length, 1);
        expect(periods.first.startDate, DateTime.parse('2025-09-09'));
        expect(periods.first.totalDays, 2);
      });

      test('updatePeriodLog by changing date should merge separate periods', () async {
        final logToUpdate = await repository.createPeriodLog(_log('2025-09-01'));
        await repository.createPeriodLog(_log('2025-09-03'));
        
        final updatedLog = logToUpdate.copyWith(date: DateTime.parse('2025-09-02'));
        await repository.updatePeriodLog(updatedLog);

        final periods = await repository.readAllPeriods();
        expect(periods.length, 1);
        expect(periods.first.totalDays, 2);
      });

      test('updating a log date to create a gap should split the period', () async {
        await repository.createPeriodLog(_log('2025-09-01'));
        final logToUpdate = await repository.createPeriodLog(_log('2025-09-02'));
        await repository.createPeriodLog(_log('2025-09-03'));

        final updatedLog = logToUpdate.copyWith(date: DateTime.parse('2025-09-05'));
        await repository.updatePeriodLog(updatedLog);

        final periods = await repository.readAllPeriods();
        expect(periods.length, 3);
      });

      test('deleting the first log should shorten the period from the start', () async {
        final logToDelete = await repository.createPeriodLog(_log('2025-09-01'));
        await repository.createPeriodLog(_log('2025-09-02'));

        await repository.deletePeriodLog(logToDelete.id!);

        final periods = await repository.readAllPeriods();
        expect(periods.length, 1);
        expect(periods.first.startDate, DateTime.parse('2025-09-02'));
        expect(periods.first.totalDays, 1);
      });

      test('deletePeriodLog from middle of a period should split it into two', () async {
        await repository.createPeriodLog(_log('2025-09-01'));
        final logToDelete = await repository.createPeriodLog(_log('2025-09-02'));
        await repository.createPeriodLog(_log('2025-09-03'));

        await repository.deletePeriodLog(logToDelete.id!);
        
        final periods = await repository.readAllPeriods();
        expect(periods.length, 2);
      });
      
      test('deleting all logs from a period sequentially should correctly remove the period', () async {
        final log1 = await repository.createPeriodLog(_log('2025-09-01'));
        final log2 = await repository.createPeriodLog(_log('2025-09-02'));
        final log3 = await repository.createPeriodLog(_log('2025-09-03'));

        await repository.deletePeriodLog(log1.id!);
        await repository.deletePeriodLog(log3.id!);
        await repository.deletePeriodLog(log2.id!);
        
        final periods = await repository.readAllPeriods();
        expect(periods, isEmpty);
      });
    });

    // --- GROUP 3: Validation and Error Handling ---
    group('Validation and Error Handling', () {
      test('createPeriodLog should throw DuplicateLogException for existing date', () async {
        await repository.createPeriodLog(_log('2025-09-01'));
        final future = repository.createPeriodLog(_log('2025-09-01'));
        expect(future, throwsA(isA<DuplicateLogException>()));
      });

      test('createPeriodLog should throw FutureDateException for a future date', () async {
        final tomorrow = DateTime.now().add(const Duration(days: 1));
        final futureLog = PeriodDay(date: tomorrow, flow: FlowRate.medium, painLevel: 0, symptoms: []);
        final futureCall = repository.createPeriodLog(futureLog);
        expect(futureCall, throwsA(isA<FutureDateException>()));
      });
        
      test('updating a log to a date that already exists should throw DuplicateLogException', () async {
        await repository.createPeriodLog(_log('2025-09-01'));
        final logToUpdate = await repository.createPeriodLog(_log('2025-09-05'));
        final updatedLog = logToUpdate.copyWith(date: DateTime.parse('2025-09-01'));
        final futureCall = repository.updatePeriodLog(updatedLog);
        expect(futureCall, throwsA(isA<DuplicateLogException>()));
      });
    });

    // --- GROUP 4: Data Integrity and Edge Cases ---
    group('Data Integrity and Edge Cases', () {
      test('updating a log with its own date should not change the period structure', () async {
        final logToUpdate = await repository.createPeriodLog(_log('2025-09-01'));
        await repository.createPeriodLog(_log('2025-09-02'));

        final updatedLog = logToUpdate.copyWith(date: DateTime.parse('2025-09-01'), flow: FlowRate.light);
        await repository.updatePeriodLog(updatedLog);

        final periods = await repository.readAllPeriods();
        expect(periods.length, 1);
        expect(periods.first.totalDays, 2);
      });
      
      test('readAllPeriods should return periods in descending order of start date', () async {
        await repository.createPeriodLog(_log('2024-09-15'));
        await repository.createPeriodLog(_log('2024-07-20'));
        await repository.createPeriodLog(_log('2024-08-25'));

        final periods = await repository.readAllPeriods();
        expect(periods[0].startDate, DateTime.parse('2024-09-15'));
        expect(periods[1].startDate, DateTime.parse('2024-08-25'));
        expect(periods[2].startDate, DateTime.parse('2024-07-20'));
      });
        
      test('periods spanning across month boundaries should have correct total days', () async {
        await repository.createPeriodLog(_log('2025-08-31'));
        await repository.createPeriodLog(_log('2025-09-01'));

        final periods = await repository.readAllPeriods();
        expect(periods.first.totalDays, 2);
      });

      test('period duration should be calculated correctly over a leap year', () async {
        await repository.createPeriodLog(_log('2024-02-28'));
        await repository.createPeriodLog(_log('2024-02-29'));
        await repository.createPeriodLog(_log('2024-03-01'));

        final periods = await repository.readAllPeriods();
        expect(periods.first.totalDays, 3);
      });
    });

    // --- GROUP 5: Read and Aggregation Operations ---
    group('Read and Aggregation Operations', () {
      test('readLastPeriod should return the most recent period', () async {
        await repository.createPeriodLog(_log('2025-08-10'));
        await repository.createPeriodLog(_log('2025-09-05'));
        final lastPeriod = await repository.readLastPeriod();
        expect(lastPeriod?.startDate, DateTime.parse('2025-09-05'));
      });

      test('readLastPeriod should return null if no periods exist', () async {
        final lastPeriod = await repository.readLastPeriod();
        expect(lastPeriod, isNull);
      });

      test('getMonthlyFlows should return correct flow data for multiple months', () async {
        await repository.createPeriodLog(_log('2025-09-01', flow: FlowRate.none));
        await repository.createPeriodLog(_log('2025-08-15', flow: FlowRate.light));
        final monthlyFlows = await repository.getMonthlyFlows();
        expect(monthlyFlows.length, 2);
        expect(monthlyFlows.firstWhere((m) => m.monthLabel == 'Sep').flows, [1]);
      });

      test('getMonthlyFlows should return an empty list when there is no data', () async {
        final monthlyFlows = await repository.getMonthlyFlows();
        expect(monthlyFlows, isEmpty);
      });
    });
      
    // --- GROUP 6: General State Management ---
    group('General State Management', () {
      test('deleteAllEntries should clear all periods and logs', () async {
        await repository.createPeriodLog(_log('2025-09-01'));
        await repository.deleteAllEntries();
        final periods = await repository.readAllPeriods();
        final logs = await repository.readAllPeriodLogs();
        expect(periods, isEmpty);
        expect(logs, isEmpty);
      });
    });
  });
}