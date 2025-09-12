import 'package:flutter_test/flutter_test.dart';
import 'package:menstrudel/database/app_database.dart';
import 'package:menstrudel/models/period_logs/period_day.dart';
import 'package:menstrudel/database/repositories/periods_repository.dart';
import 'package:menstrudel/utils/exceptions.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

PeriodDay _log(String date, {int flow = 2}) =>
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

    group('General Operations', (){
      test('deleteAllEntries should clear all periods and logs', () async {
        await repository.createPeriodLog(_log('2025-09-01'));
        var periods = await repository.readAllPeriods();
        var logs = await repository.readAllPeriodLogs();
        expect(periods, isNotEmpty);
        expect(logs, isNotEmpty);

        await repository.deleteAllEntries();

        periods = await repository.readAllPeriods();
        logs = await repository.readAllPeriodLogs();
        expect(periods, isEmpty);
        expect(logs, isEmpty);
      });
    });

    group('Period Logs - Create Operations', () {
      test('createPeriodLog should add a log and create a new period', () async {
        await repository.createPeriodLog(_log('2025-09-01'));
        
        final logs = await repository.readAllPeriodLogs();
        expect(logs.length, 1);
        expect(logs.first.date, DateTime.parse('2025-09-01'));

        final periods = await repository.readAllPeriods();
        expect(periods.length, 1);
        expect(periods.first.startDate, DateTime.parse('2025-09-01'));
        expect(periods.first.endDate, DateTime.parse('2025-09-01'));
        expect(periods.first.totalDays, 1);
      });

      test('creating consecutive logs should extend the existing period', () async {
        await repository.createPeriodLog(_log('2025-09-01'));
        await repository.createPeriodLog(_log('2025-09-02'));

        final periods = await repository.readAllPeriods();
        expect(periods.length, 1);
        expect(periods.first.startDate, DateTime.parse('2025-09-01'));
        expect(periods.first.endDate, DateTime.parse('2025-09-02'));
        expect(periods.first.totalDays, 2);
      });

      test('creating a log with a gap should result in a new period', () async {
        await repository.createPeriodLog(_log('2025-09-01'));
        await repository.createPeriodLog(_log('2025-09-02'));

        await repository.createPeriodLog(_log('2025-09-05')); 

        final periods = await repository.readAllPeriods();
        expect(periods.length, 2);
        
        expect(periods[0].startDate, DateTime.parse('2025-09-05'));
        expect(periods[0].totalDays, 1);
        
        expect(periods[1].startDate, DateTime.parse('2025-09-01'));
        expect(periods[1].totalDays, 2);
      });

      test('creating a log between two existing periods should merge them into one', () async {
        await repository.createPeriodLog(_log('2025-09-01'));
        await repository.createPeriodLog(_log('2025-09-02'));

        await repository.createPeriodLog(_log('2025-09-04'));
        await repository.createPeriodLog(_log('2025-09-05'));
        
        var periods = await repository.readAllPeriods();
        expect(periods.length, 2, reason: 'Should initially be two separate periods');

        await repository.createPeriodLog(_log('2025-09-03'));

        periods = await repository.readAllPeriods();
        expect(periods.length, 1, reason: 'The periods should now be merged');
        expect(periods.first.startDate, DateTime.parse('2025-09-01'));
        expect(periods.first.endDate, DateTime.parse('2025-09-05'));
        expect(periods.first.totalDays, 5);
      });

      test('creating a log between two existing periods should merge them into one', () async {
        await repository.createPeriodLog(_log('2025-09-01'));
        await repository.createPeriodLog(_log('2025-09-02'));

        await repository.createPeriodLog(_log('2025-09-04'));
        await repository.createPeriodLog(_log('2025-09-05'));
        
        var periods = await repository.readAllPeriods();
        expect(periods.length, 2, reason: 'Should initially be two separate periods');

        await repository.createPeriodLog(_log('2025-09-03'));

        periods = await repository.readAllPeriods();
        expect(periods.length, 1, reason: 'The periods should now be merged');
        expect(periods.first.startDate, DateTime.parse('2025-09-01'));
        expect(periods.first.endDate, DateTime.parse('2025-09-05'));
        expect(periods.first.totalDays, 5);
      });

      group('Exceptions', () {
        test('createPeriodLog should throw DuplicateLogException for existing date', () async {
          await repository.createPeriodLog(_log('2025-09-01'));
          
          final future = repository.createPeriodLog(_log('2025-09-01'));
          expect(future, throwsA(isA<DuplicateLogException>()));
        });

        test('createPeriodLog should throw FutureDateException for a future date', () async {
          final tomorrow = DateTime.now().add(const Duration(days: 1));
          final futureLog = PeriodDay(date: tomorrow, flow: 2, painLevel: 0, symptoms: []);

          final futureCall = repository.createPeriodLog(futureLog);
          expect(futureCall, throwsA(isA<FutureDateException>()));
        });
      });
    });

    group('Period Logs - Read Operations', () {
      test('readAllPeriods should return periods in descending order of start date', () async {
        await repository.createPeriodLog(_log('2024-09-15'));
        await repository.createPeriodLog(_log('2024-07-20'));
        await repository.createPeriodLog(_log('2024-08-25'));

        final periods = await repository.readAllPeriods();

        expect(periods.length, 3);
        expect(periods[0].startDate, DateTime.parse('2024-09-15'));
        expect(periods[1].startDate, DateTime.parse('2024-08-25'));
        expect(periods[2].startDate, DateTime.parse('2024-07-20'));
      });

      test('periods spanning across month boundaries should have correct total days', () async {
        await repository.createPeriodLog(_log('2025-08-31'));
        await repository.createPeriodLog(_log('2025-09-01'));

        final periods = await repository.readAllPeriods();
        
        expect(periods.length, 1);
        expect(periods.first.startDate, DateTime.parse('2025-08-31'));
        expect(periods.first.endDate, DateTime.parse('2025-09-01'));
        expect(periods.first.totalDays, 2);
      });
    });
    
    group('Period Logs - Update Operations', () {
      test('adding a back-dated log should correctly extend an existing period backwards', () async {
        await repository.createPeriodLog(_log('2025-09-10'));
        await repository.createPeriodLog(_log('2025-09-11'));

        var periods = await repository.readAllPeriods();
        expect(periods.first.startDate, DateTime.parse('2025-09-10'));
        expect(periods.first.totalDays, 2);

        await repository.createPeriodLog(_log('2025-09-09'));

        periods = await repository.readAllPeriods();
        expect(periods.length, 1);
        expect(periods.first.startDate, DateTime.parse('2025-09-09'));
        expect(periods.first.totalDays, 3);
      });
      test('updatePeriodLog by changing date should correctly recalculate periods', () async {
        final logToUpdate = await repository.createPeriodLog(_log('2025-09-01'));
        await repository.createPeriodLog(_log('2025-09-03'));

        var periods = await repository.readAllPeriods();
        expect(periods.length, 2);

        final updatedLog = logToUpdate.copyWith(date: DateTime.parse('2025-09-02'));
        await repository.updatePeriodLog(updatedLog);

        periods = await repository.readAllPeriods();
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
        
        expect(
          periods.any((p) => p.startDate == DateTime.parse('2025-09-01') && p.totalDays == 1),
          isTrue,
          reason: 'Should have a period for Sep 1st',
        );
        expect(
          periods.any((p) => p.startDate == DateTime.parse('2025-09-03') && p.totalDays == 1),
          isTrue,
          reason: 'Should have a period for Sep 3rd',
        );
        expect(
          periods.any((p) => p.startDate == DateTime.parse('2025-09-05') && p.totalDays == 1),
          isTrue,
          reason: 'Should have a period for the updated log on Sep 5th',
        );
      });

      test('updating a log to a date that already exists should throw DuplicateLogException', () async {
        await repository.createPeriodLog(_log('2025-09-01'));
        final logToUpdate = await repository.createPeriodLog(_log('2025-09-05'));

        final updatedLog = logToUpdate.copyWith(date: DateTime.parse('2025-09-01'));
        
        final futureCall = repository.updatePeriodLog(updatedLog);
        expect(futureCall, throwsA(isA<DuplicateLogException>()));
      });

      test('updating a log flow should not affect period structure', () async {
        final logToUpdate = await repository.createPeriodLog(_log('2025-09-01', flow: 1));
        await repository.createPeriodLog(_log('2025-09-02'));

        final updatedLog = logToUpdate.copyWith(flow: 5);
        await repository.updatePeriodLog(updatedLog);

        final periods = await repository.readAllPeriods();
        expect(periods.length, 1);
        expect(periods.first.totalDays, 2);
        
        final allLogs = await repository.readAllPeriodLogs();
        final changedLog = allLogs.firstWhere((log) => log.id == logToUpdate.id);
        expect(changedLog.flow, 5);
      });
    });

    group('Period Logs - Delete Operations', () {
      test('deleting the first log should shorten the period from the start', () async {
        final logToDelete = await repository.createPeriodLog(_log('2025-09-01'));
        await repository.createPeriodLog(_log('2025-09-02'));

        await repository.deletePeriodLog(logToDelete!.id!);

        final periods = await repository.readAllPeriods();
        expect(periods.length, 1);
        expect(periods.first.startDate, DateTime.parse('2025-09-02'));
        expect(periods.first.endDate, DateTime.parse('2025-09-02'));
        expect(periods.first.totalDays, 1);
      });

      test('deletePeriodLog from middle of a period should split it into two', () async {
        await repository.createPeriodLog(_log('2025-09-01'));
        final logToDelete = await repository.createPeriodLog(_log('2025-09-02'));
        await repository.createPeriodLog(_log('2025-09-03'));

        var periods = await repository.readAllPeriods();
        expect(periods.length, 1);
        expect(periods.first.totalDays, 3);

        await repository.deletePeriodLog(logToDelete.id!);
        
        periods = await repository.readAllPeriods();
        expect(periods.length, 2);
        expect(periods[0].totalDays, 1);
        expect(periods[1].totalDays, 1);
      });

      test('deleting the only log should remove the period entirely', () async {
        final logToDelete = await repository.createPeriodLog(_log('2025-09-01'));

        await repository.deletePeriodLog(logToDelete.id!);

        final periods = await repository.readAllPeriods();
        final logs = await repository.readAllPeriodLogs();
        expect(periods, isEmpty);
        expect(logs, isEmpty);
      });

      test('deleting all logs from a period sequentially should correctly remove the period', () async {
        final log1 = await repository.createPeriodLog(_log('2025-09-01'));
        final log2 = await repository.createPeriodLog(_log('2025-09-02'));
        final log3 = await repository.createPeriodLog(_log('2025-09-03'));

        await repository.deletePeriodLog(log1.id!);
        var periods = await repository.readAllPeriods();
        expect(periods.first.totalDays, 2);
        expect(periods.first.startDate, DateTime.parse('2025-09-02'));

        await repository.deletePeriodLog(log3.id!);
        periods = await repository.readAllPeriods();
        expect(periods.first.totalDays, 1);
        expect(periods.first.startDate, DateTime.parse('2025-09-02'));
        expect(periods.first.endDate, DateTime.parse('2025-09-02'));

        await repository.deletePeriodLog(log2.id!);
        periods = await repository.readAllPeriods();
        expect(periods, isEmpty, reason: 'The period should be gone after its last log is deleted');
      });
    });

    group('Period - Read Operations', () {
      test('readLastPeriod should return the most recent period', () async {
        await repository.createPeriodLog(_log('2025-08-10'));
        await repository.createPeriodLog(_log('2025-09-05'));

        final lastPeriod = await repository.readLastPeriod();

        expect(lastPeriod, isNotNull);
        expect(lastPeriod!.startDate, DateTime.parse('2025-09-05'));
      });

      test('readLastPeriod should return null if no periods exist', () async {
        final lastPeriod = await repository.readLastPeriod();
        expect(lastPeriod, isNull);
      });
    });

    group('getMonthlyFlows', () {
      test('should return correct flow data for multiple months', () async {
        await repository.createPeriodLog(_log('2025-09-01', flow: 1));
        await repository.createPeriodLog(_log('2025-09-02', flow: 2));

        await repository.createPeriodLog(_log('2025-08-15', flow: 3));
        await repository.createPeriodLog(_log('2025-08-16', flow: 2));
        await repository.createPeriodLog(_log('2025-08-17', flow: 3));

        final monthlyFlows = await repository.getMonthlyFlows();

        expect(monthlyFlows.length, 2);

        expect(monthlyFlows[0].monthLabel, 'Sep');
        expect(monthlyFlows[0].flows, [1, 2]);

        expect(monthlyFlows[1].monthLabel, 'Aug');
        expect(monthlyFlows[1].flows, [3, 2, 3]);
      });

      test('should return an empty list when there is no data', () async {
        final monthlyFlows = await repository.getMonthlyFlows();
        expect(monthlyFlows, isEmpty);
      });
    });
  });
}