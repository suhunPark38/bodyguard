import 'package:drift/drift.dart';

@DataClassName('DailyActivityInfo')
class DailyActivityInfo extends Table{
  DateTimeColumn get recordDate => dateTime()();
  RealColumn get totalCalorieIntake => real()();
  RealColumn get totalCalorieBurned => real()();
  RealColumn get waterIntake => real()();

  @override
  Set<Column> get primaryKey => {recordDate};
}
