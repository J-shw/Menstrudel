import 'package:flutter_test/flutter_test.dart';
import 'package:menstrudel/database/app_database.dart';
import 'package:menstrudel/models/period_logs/period_logs.dart';
import 'package:menstrudel/database/repositories/periods_repository.dart';
import 'package:menstrudel/utils/exceptions.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

PeriodLogEntry _log(String date, {int flow = 2}) =>
    PeriodLogEntry(date: DateTime.parse(date), flow: flow, symptoms: [], painLevel: 0);

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

    group('Period Logs CRUD and Period Calculation', () {
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

      test('createPeriodLog should throw DuplicateLogException for existing date', () async {
        await repository.createPeriodLog(_log('2025-09-01'));
        
        final future = repository.createPeriodLog(_log('2025-09-01'));
        expect(future, throwsA(isA<DuplicateLogException>()));
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
    });

    group('Period Read Operations', () {
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