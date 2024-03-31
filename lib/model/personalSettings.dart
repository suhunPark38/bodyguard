import 'package:drift/drift.dart';

@DataClassName('PersonalSettings')
class PersonalSettings extends Table{
  TextColumn get userId => text()();
  TextColumn get nickname => text()();
  RealColumn get height => real()();
  RealColumn get weight => real()();
  IntColumn get age => integer()();
  RealColumn get recommenedCalories => real()();
  RealColumn get targetCalories => real()();
  RealColumn get targetWaterIntake => real()();

  @override
  Set<Column> get primaryKey => {userId};
}