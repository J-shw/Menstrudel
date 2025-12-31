import 'package:flutter_test/flutter_test.dart';
import 'package:menstrudel/database/app_database.dart';
import 'package:menstrudel/models/flows/flow_enum.dart';
import 'package:menstrudel/models/period_logs/log_day.dart';
import 'package:menstrudel/database/repositories/logs_repository.dart';
import 'package:menstrudel/utils/exceptions.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

LogDay _log(String date, {FlowRate flow = FlowRate.medium}) =>
    LogDay(date: DateTime.parse(date), flow: flow, symptoms: [], painLevel: 0);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  databaseFactory = databaseFactoryFfi;
  sqfliteFfiInit();

  group('LogsRepository Tests', () {
    late LogsRepository repository;
    late AppDatabase dbProvider;

    setUp(() async {
      dbProvider = AppDatabase.instance;
      await dbProvider.init(inMemory: true);
      repository = LogsRepository();
    });

    tearDown(() async {
      await dbProvider.close();
    });

    group('Core Log Operations (CRUD)', () {
      test('upsertLog should save a new LogDay', () async {
        await repository.upsertLog(_log('2025-09-01'));
        final logs = await repository.readAllLogs();
        expect(logs.length, 1);
        expect(logs.first.date, DateTime.parse('2025-09-01'));
      });

      test('upsertLog should update an existing entry', () async {
        final id = await repository.upsertLog(_log('2025-09-01', flow: FlowRate.light));
        await repository.upsertLog(_log('2025-09-01', flow: FlowRate.heavy).copyWith(id: id));

        final logs = await repository.readAllLogs();
        expect(logs.length, 1);
        expect(logs.first.flow, FlowRate.heavy);
      });

      test('deleteLog should remove a specific entry', () async {
        final id = await repository.upsertLog(_log('2025-09-01'));
        await repository.deleteLog(id);
        final logs = await repository.readAllLogs();
        expect(logs, isEmpty);
      });
    });

    group('Validation and Error Handling', () {
      test('upsertLog should throw DuplicateLogException for existing date', () async {
        await repository.upsertLog(_log('2025-09-01'));
        expect(() => repository.upsertLog(_log('2025-09-01')), 
            throwsA(isA<DuplicateLogException>()));
      });

      test('upsertLog should throw FutureDateException for a future date', () async {
        final tomorrow = DateTime.now().add(const Duration(days: 1));
        expect(() => repository.upsertLog(LogDay(date: tomorrow, flow: FlowRate.medium, painLevel: 0, symptoms: [])), 
            throwsA(isA<FutureDateException>()));
      });
    });
  });
}