import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:menstrudel/database/app_database.dart';
import 'package:menstrudel/database/repositories/sanitary_product_repository.dart';
import 'package:menstrudel/models/sanitary_products/sanitary_products_entry.dart';
import 'package:menstrudel/models/sanitary_products/sanitary_products_enum.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

SanitaryProductsEntry _product(String logTime, {DateTime? removedTime, int? id}) {
  final time = DateTime.parse(logTime);
  return SanitaryProductsEntry(
    id: id,
    logTime: time,
    reminderTime: time.add(const Duration(hours: 4)),
    removedTime: removedTime,
    type: SanitaryProducts.tampon,
    note: 'Test note',
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  databaseFactory = databaseFactoryFfi;
  sqfliteFfiInit();

  group('SanitaryProductRepository Tests', () {
    late SanitaryProductRepository repository;
    late AppDatabase dbProvider;

    setUp(() async {
      dbProvider = AppDatabase.instance;
      await dbProvider.init(inMemory: true);
      repository = SanitaryProductRepository();
    });

    tearDown(() async {
      await dbProvider.close();
    });

    group('Core Product Operations', () {
      test('logSanitaryProduct should save a new entry', () async {
        await repository.logSanitaryProduct(_product('2025-12-31T10:00:00'));
        final logs = await repository.getAllLogs();
        expect(logs.length, 1);
        expect(logs.first.type, SanitaryProducts.tampon);
      });

      test('getActiveEntry should return entry with null removedTime', () async {
        // Log an old inactive entry
        await repository.logSanitaryProduct(_product('2025-12-30T08:00:00', 
            removedTime: DateTime.parse('2025-12-30T12:00:00'))); 
        // Log the current active entry
        await repository.logSanitaryProduct(_product('2025-12-31T13:00:00')); 

        final active = await repository.getActiveEntry();
        expect(active, isNotNull);
        expect(active!.removedTime, isNull);
        expect(active.logTime, DateTime.parse('2025-12-31T13:00:00'));
      });

      test('markEntryAsRemoved should set the removed timestamp', () async {
        await repository.logSanitaryProduct(_product('2025-12-31T10:00:00'));
        final entry = (await repository.getAllLogs()).first;
        final removedAt = DateTime.parse('2025-12-31T14:00:00');

        await repository.markEntryAsRemoved(entry.id!, removedAt);
        
        final updated = await repository.getLogById(entry.id!);
        expect(updated!.removedTime, removedAt);
      });

      test('getInactiveLogs should only return removed items', () async {
        await repository.logSanitaryProduct(_product('2025-12-30T08:00:00', 
            removedTime: DateTime.parse('2025-12-30T12:00:00')));
        await repository.logSanitaryProduct(_product('2025-12-31T13:00:00')); 

        final inactive = await repository.getInactiveLogs();
        expect(inactive.length, 1);
        expect(inactive.first.removedTime, isNotNull);
      });
    });

    group('Manager (Import/Export)', () {
      test('importDataFromJson should restore logs correctly', () async {
        final mockData = jsonEncode({
          'sanitary_product_logs': [
            {
              'logTime': '2025-12-31T10:00:00.000',
              'reminderTime': '2025-12-31T14:00:00.000',
              'type': 'pad',
              'note': 'Imported',
              'removedTime': null
            }
          ],
          'db_version': 1
        });

        await repository.manager.importDataFromJson(mockData);
        final logs = await repository.getAllLogs();
        expect(logs.length, 1);
        expect(logs.first.note, 'Imported');
      });

      test('clearAllData should wipe the table', () async {
        await repository.logSanitaryProduct(_product('2025-12-31T10:00:00'));
        await repository.manager.clearAllData();
        final logs = await repository.getAllLogs();
        expect(logs, isEmpty);
      });
    });
  });
}