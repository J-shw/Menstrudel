import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:menstrudel/database/app_database.dart';
import 'package:menstrudel/database/repositories/larc_repository.dart';
import 'package:menstrudel/models/birth_control/larcs/larc_log_entry.dart';
import 'package:menstrudel/models/birth_control/larcs/larc_types_enum.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

LarcLogEntry _larc(String date, {LarcTypes type = LarcTypes.iud, int? id}) => 
    LarcLogEntry(
      id: id,
      date: DateTime.parse(date),
      type: type,
      note: 'Test LARC note',
    );

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  databaseFactory = databaseFactoryFfi;
  sqfliteFfiInit();

  group('LarcRepository Tests', () {
    late LarcRepository repository;
    late AppDatabase dbProvider;

    setUp(() async {
      dbProvider = AppDatabase.instance;
      await dbProvider.init(inMemory: true);
      repository = LarcRepository();
    });

    tearDown(() async {
      await dbProvider.close();
    });

    group('Core LARC Operations (CRUD)', () {
      test('logLarc should save a new entry', () async {
        await repository.logLarc(_larc('2025-01-01'));
        final logs = await repository.getAllLogs();
        expect(logs.length, 1);
        expect(logs.first.type, LarcTypes.iud);
      });

      test('getLogById should return the correct entry', () async {
        await repository.logLarc(_larc('2025-01-01'));
        final all = await repository.getAllLogs();
        final id = all.first.id!;
        
        final log = await repository.getLogById(id);
        expect(log, isNotNull);
        expect(log!.id, id);
      });

      test('updateLog should modify an existing entry', () async {
        await repository.logLarc(_larc('2025-01-01', type: LarcTypes.iud));
        var log = (await repository.getAllLogs()).first;
        
        final updatedLog = log.copyWith(type: LarcTypes.implant, note: 'Updated');
        
        await repository.updateLog(updatedLog);
        final result = await repository.getLogById(log.id!);
        expect(result!.type, LarcTypes.implant);
        expect(result.note, 'Updated');
      });

      test('deleteLog should remove a specific entry', () async {
        await repository.logLarc(_larc('2025-01-01'));
        final id = (await repository.getAllLogs()).first.id!;
        
        await repository.deleteLog(id);
        final logs = await repository.getAllLogs();
        expect(logs, isEmpty);
      });
    });

    group('Manager (Import/Export)', () {
      test('importDataFromJson should restore logs correctly', () async {
        final mockData = jsonEncode({
          'larc_logs': [
            {
              'date': '2025-05-05T00:00:00.000', 
              'type': 'injection', 
              'note': 'Imported note'
            }
          ],
          'db_version': 1
        });

        await repository.manager.importDataFromJson(mockData);
        final logs = await repository.getAllLogs();
        expect(logs.length, 1);
        expect(logs.first.type, LarcTypes.injection);
      });

      test('clearAllData should wipe the table', () async {
        await repository.logLarc(_larc('2025-01-01'));
        await repository.manager.clearAllData();
        final logs = await repository.getAllLogs();
        expect(logs, isEmpty);
      });
    });
  });
}