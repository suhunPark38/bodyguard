import 'package:drift/drift.dart';

@DataClassName('DailyActivityDetail')
class DailyActivityDetail extends Table{
  DateTimeColumn get recordDate => dateTime()();
  TextColumn get activityName => text()();
  RealColumn get calorieBurned => real()();
  DateTimeColumn get startTime => dateTime()();
  DateTimeColumn get endTime => dateTime()();

  @override
  Set<Column> get primaryKey => {recordDate};

}
