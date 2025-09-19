import 'package:flutter_test/flutter_test.dart';
import 'package:menstrudel/database/app_database.dart';
import 'package:menstrudel/database/repositories/pills_repository.dart';
import 'package:menstrudel/models/pills/pill_intake.dart';
import 'package:menstrudel/models/pills/pill_regimen.dart';
import 'package:menstrudel/models/pills/pill_reminder.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:menstrudel/models/pills/pill_status_enum.dart';

void main() {
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  group('PillsRepository Tests', () {
    late PillsRepository repository;
    late AppDatabase dbProvider;

    // Helper models using your final classes
    final regimenA = PillRegimen(name: 'Regimen A', activePills: 21, placeboPills: 7, startDate: DateTime(2025, 9, 1), isActive: true);
    final regimenB = PillRegimen(name: 'Regimen B', activePills: 28, placeboPills: 0, startDate: DateTime(2025, 9, 1), isActive: true);

    setUp(() async {
      dbProvider = AppDatabase.instance;
      await dbProvider.init(inMemory: true);
      repository = PillsRepository();
    });

    tearDown(() async {
      await dbProvider.close();
    });

    // --- GROUP 1: Pill Regimen Management ---
    group('Pill Regimen Management', () {
      test('createPillRegimen successfully adds a new regimen', () async {
        final created = await repository.createPillRegimen(regimenA);
        expect(created.id, isNotNull);
        expect(created.name, 'Regimen A');
      });

      test('createPillRegimen deactivates the previously active regimen', () async {
        await repository.createPillRegimen(regimenA);
        final newActive = await repository.createPillRegimen(regimenB);

        final activeRegimen = await repository.readActivePillRegimen();
        expect(activeRegimen?.id, newActive.id);
      });

      test('readActivePillRegimen returns the correct active regimen', () async {
        await repository.createPillRegimen(regimenA.copyWith(isActive: false));
        final active = await repository.createPillRegimen(regimenB);

        final result = await repository.readActivePillRegimen();
        expect(result?.id, active.id);
      });
      
      test('deletePillRegimen successfully removes a regimen', () async {
        final regimen = await repository.createPillRegimen(regimenA);
        await repository.deletePillRegimen(regimen.id!);
        final result = await repository.readActivePillRegimen();
        expect(result, isNull);
      });
    });

    // --- GROUP 2: Pill Intake Tracking ---
    group('Pill Intake Tracking', () {
      test('createPillIntake successfully adds a record', () async {
        final regimen = await repository.createPillRegimen(regimenA);
        final intake = PillIntake(
          regimenId: regimen.id!,
          takenAt: DateTime.now(),
          scheduledDate: DateTime(2025, 9, 1),
          status: PillIntakeStatus.taken,
          pillNumberInCycle: 1,
        );
        
        final createdIntake = await repository.createPillIntake(intake);
        expect(createdIntake.id, isNotNull);
        expect(createdIntake.status, PillIntakeStatus.taken);
      });

      test('readIntakesForRegimen returns only intakes for the specified regimen', () async {
        final createdRegimenA = await repository.createPillRegimen(regimenA);
        final createdRegimenB = await repository.createPillRegimen(regimenB);

        await repository.createPillIntake(PillIntake(regimenId: createdRegimenA.id!, takenAt: DateTime.now(), scheduledDate: DateTime(2025, 9, 1), status: PillIntakeStatus.taken, pillNumberInCycle: 1));
        await repository.createPillIntake(PillIntake(regimenId: createdRegimenB.id!, takenAt: DateTime.now(), scheduledDate: DateTime(2025, 9, 1), status: PillIntakeStatus.taken, pillNumberInCycle: 1));
        await repository.createPillIntake(PillIntake(regimenId: createdRegimenA.id!, takenAt: DateTime.now(), scheduledDate: DateTime(2025, 9, 2), status: PillIntakeStatus.skipped, pillNumberInCycle: 2));

        final intakes = await repository.readIntakesForRegimen(createdRegimenA.id!);
        expect(intakes.length, 2);
        expect(intakes.every((i) => i.regimenId == createdRegimenA.id!), isTrue);
      });

      test('readIntakesForRegimen returns an empty list for a regimen with no intakes', () async {
        final regimen = await repository.createPillRegimen(regimenA);
        final intakes = await repository.readIntakesForRegimen(regimen.id!);
        expect(intakes, isEmpty);
      });
    });

    // --- GROUP 3: Pill Reminder (Upsert Logic) ---
    group('Pill Reminder (Upsert Logic)', () {
      test('savePillReminder creates a new reminder if one does not exist', () async {
        final regimen = await repository.createPillRegimen(regimenA);
        final reminder = PillReminder(regimenId: regimen.id!, reminderTime: '08:30', isEnabled: true);

        await repository.savePillReminder(reminder);

        final result = await repository.readReminderForRegimen(regimen.id!);
        expect(result, isNotNull);
        expect(result!.reminderTime, '08:30');
        expect(result.isEnabled, isTrue);
      });

      test('savePillReminder updates an existing reminder for the same regimen', () async {
        final regimen = await repository.createPillRegimen(regimenA);
        await repository.savePillReminder(PillReminder(regimenId: regimen.id!, reminderTime: '08:00', isEnabled: true));
        await repository.savePillReminder(PillReminder(regimenId: regimen.id!, reminderTime: '10:30', isEnabled: false));
        
        final result = await repository.readReminderForRegimen(regimen.id!);
        expect(result, isNotNull);
        expect(result!.reminderTime, '10:30');
        expect(result.isEnabled, isFalse);
      });

      test('readReminderForRegimen returns null if no reminder exists', () async {
        final regimen = await repository.createPillRegimen(regimenA);
        final result = await repository.readReminderForRegimen(regimen.id!);
        expect(result, isNull);
      });
    });

    // --- GROUP 4: Data Integrity and Relationships ---
    group('Data Integrity and Relationships', () {
      test('deletePillRegimen does not delete associated intakes', () async {
        final regimen = await repository.createPillRegimen(regimenA);
        await repository.createPillIntake(PillIntake(regimenId: regimen.id!, takenAt: DateTime.now(), scheduledDate: DateTime(2025, 9, 1), status: PillIntakeStatus.taken, pillNumberInCycle: 1));
        await repository.deletePillRegimen(regimen.id!);
        final intakes = await repository.readIntakesForRegimen(regimen.id!);
        expect(intakes, isNotEmpty);
      });

      test('deletePillRegimen does not delete the associated reminder', () async {
        final regimen = await repository.createPillRegimen(regimenA);
        await repository.savePillReminder(PillReminder(regimenId: regimen.id!, reminderTime: '08:00', isEnabled: true));
        await repository.deletePillRegimen(regimen.id!);
        final reminder = await repository.readReminderForRegimen(regimen.id!);
        expect(reminder, isNotNull);
      });
    });

    // --- GROUP 5: Empty State Behavior ---
    group('Empty State Behavior', () {
      test('readActivePillRegimen returns null when database is empty', () async {
        final result = await repository.readActivePillRegimen();
        expect(result, isNull);
      });

      test('readIntakesForRegimen returns an empty list for a non-existent regimen ID', () async {
        final result = await repository.readIntakesForRegimen(999);
        expect(result, isEmpty);
      });
    });
  });
}