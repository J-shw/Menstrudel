import 'package:flutter_test/flutter_test.dart';
import 'package:menstrudel/database/app_database.dart';
import 'package:menstrudel/database/repositories/pills_repository.dart';
import 'package:menstrudel/models/pills/pill_regimen.dart';
import 'package:menstrudel/models/pills/pill_reminder.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

PillRegimen _regimen({String name = 'Regimen A', bool isActive = true}) =>
    PillRegimen(name: name, activePills: 21, placeboPills: 7, startDate: DateTime.now(), isActive: isActive);

PillReminder _reminder(int regimenId) =>
    PillReminder(regimenId: regimenId, reminderTime: '10:00', isEnabled: true);


void main() {
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  group('PillsRepository Tests', () {
    late PillsRepository repository;
    late AppDatabase dbProvider;

    setUp(() async {
      dbProvider = AppDatabase.instance;
      await dbProvider.init(inMemory: true);
      repository = PillsRepository();
    });

    tearDown(() async {
      await dbProvider.close();
    });


    group('Pill Regimen - Create Operations', (){
      test('createPillRegimen should create a new regimen', () async {
        final regimen = _regimen();
        final createdRegimen = await repository.createPillRegimen(regimen);

        expect(createdRegimen.id, isNotNull);
        expect(createdRegimen.name, regimen.name);
        expect(createdRegimen.activePills, regimen.activePills);
        expect(createdRegimen.placeboPills, regimen.placeboPills);
        expect(createdRegimen.startDate.day, regimen.startDate.day);
        expect(createdRegimen.isActive, isTrue);

        final readRegimen = await repository.readActivePillRegimen();
        expect(readRegimen, isNotNull);
        expect(readRegimen!.id, createdRegimen.id);
      });

      test('createPillRegimen should deactivate the previous active regimen', () async {
        final firstRegimen = await repository.createPillRegimen(_regimen(name: 'First'));
        expect(firstRegimen.isActive, isTrue);

        final secondRegimen = await repository.createPillRegimen(_regimen(name: 'Second'));

        expect(secondRegimen.isActive, isTrue);
        
        final activeRegimen = await repository.readActivePillRegimen();
        expect(activeRegimen, isNotNull);
        expect(activeRegimen!.id, secondRegimen.id);
        expect(activeRegimen.name, 'Second');
      });
    });


    // group('Pill Reminder', () { //  - - - - Does not work yet...
    //   test('savePillReminder should update an existing reminder', () async {
    //     final regimen = await repository.createPillRegimen(_regimen());
    //     await repository.savePillReminder(_reminder(regimen.id!)); 

    //     final updatedReminderData = _reminder(regimen.id!).copyWith(reminderTime: '12:30');
    //     await repository.savePillReminder(updatedReminderData);

    //     final reminder = await repository.readReminderForRegimen(regimen.id!);
    //     expect(reminder, isNotNull);
    //     expect(reminder!.reminderTime, '12:30');
    //   });
    // });
  });
}