import 'package:flutter_test/flutter_test.dart';
import 'package:menstrudel/database/app_database.dart';
import 'package:menstrudel/models/flows/flow_enum.dart';
import 'package:menstrudel/models/period_logs/log_day.dart';
import 'package:menstrudel/database/repositories/periods_repository.dart';
import 'package:menstrudel/database/repositories/logs_repository.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

LogDay _log(String date, {FlowRate flow = FlowRate.medium}) =>
    LogDay(date: DateTime.parse(date), flow: flow, symptoms: [], painLevel: 0);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  databaseFactory = databaseFactoryFfi;
  sqfliteFfiInit();

  group('PeriodsRepository Tests', () {
    late PeriodsRepository periodsRepo;
    late LogsRepository logsRepo;
    late AppDatabase dbProvider;

    setUp(() async {
      dbProvider = AppDatabase.instance;
      await dbProvider.init(inMemory: true);
      periodsRepo = PeriodsRepository();
      logsRepo = LogsRepository();
    });

    tearDown(() async {
      await dbProvider.close();
    });

    group('Period Recalculation Logic', () {
      test('consecutive logs should be assigned to the same period', () async {
        await logsRepo.upsertLog(_log('2025-09-01'));
        await logsRepo.upsertLog(_log('2025-09-02'));

        final allLogs = await logsRepo.readAllLogs();
        
        await periodsRepo.recalculateAndAssignPeriods(allLogs);

        final periods = await periodsRepo.readAllPeriods();
        expect(periods.length, 1);
        expect(periods.first.totalDays, 2);
      });

      test('logs with a 1+ day gap should create separate periods', () async {
        await logsRepo.upsertLog(_log('2025-09-01'));
        await logsRepo.upsertLog(_log('2025-09-03')); // 1 day gap (Sep 2)

        final allLogs = await logsRepo.readAllLogs();

        await periodsRepo.recalculateAndAssignPeriods(allLogs);

        final periods = await periodsRepo.readAllPeriods();
        expect(periods.length, 2);
      });

      test('bridging a gap should merge two periods into one', () async {
        await logsRepo.upsertLog(_log('2025-09-01'));
        await logsRepo.upsertLog(_log('2025-09-03'));
        final allLogs_1 = await logsRepo.readAllLogs();
        await periodsRepo.recalculateAndAssignPeriods(allLogs_1);
        expect((await periodsRepo.readAllPeriods()).length, 2);

        await logsRepo.upsertLog(_log('2025-09-02'));
        final allLogs_2 = await logsRepo.readAllLogs();
        await periodsRepo.recalculateAndAssignPeriods(allLogs_2);

        final periods = await periodsRepo.readAllPeriods();
        expect(periods.length, 1);
        expect(periods.first.totalDays, 3);
      });

      test('creating a gap by deleting a middle log should split the period', () async {
        await logsRepo.upsertLog(_log('2025-09-01'));
        final midId = await logsRepo.upsertLog(_log('2025-09-02'));
        await logsRepo.upsertLog(_log('2025-09-03'));

        await logsRepo.deleteLog(midId);
        final allLogs = await logsRepo.readAllLogs();
        await periodsRepo.recalculateAndAssignPeriods(allLogs);

        final periods = await periodsRepo.readAllPeriods();
        expect(periods.length, 2);
      });

      test('FlowRate.none logs should act as gaps and not be part of periods', () async {
        await logsRepo.upsertLog(_log('2025-09-01'));
        await logsRepo.upsertLog(_log('2025-09-02', flow: FlowRate.none));
        await logsRepo.upsertLog(_log('2025-09-03'));

        final allLogs = await logsRepo.readAllLogs();
        await periodsRepo.recalculateAndAssignPeriods(allLogs);

        final periods = await periodsRepo.readAllPeriods();
        expect(periods.length, 2); // Split by the "none" flow log
      });
    });

    group('Read and Aggregation Operations', () {
      test('readLastPeriod should return the newest cycle', () async {
        await logsRepo.upsertLog(_log('2025-01-01'));
        await logsRepo.upsertLog(_log('2025-03-01'));

        final allLogs = await logsRepo.readAllLogs();
        await periodsRepo.recalculateAndAssignPeriods(allLogs);

        final last = await periodsRepo.readLastPeriod();
        expect(last?.startDate, DateTime.parse('2025-03-01'));
      });

      test('readAllPeriods should return periods in descending order', () async {
        await logsRepo.upsertLog(_log('2025-01-01'));
        await logsRepo.upsertLog(_log('2025-05-01'));

        final allLogs = await logsRepo.readAllLogs();
        await periodsRepo.recalculateAndAssignPeriods(allLogs);

        final all = await periodsRepo.readAllPeriods();
        expect(all[0].startDate, DateTime.parse('2025-05-01'));
        expect(all[1].startDate, DateTime.parse('2025-01-01'));
      });
    });
  });
}