import 'package:drift/drift.dart';

@DataClassName('Diet')
class Diet extends Table{
  IntColumn get dietId => integer().autoIncrement()();
  DateTimeColumn get eatingTime => dateTime()();
  TextColumn get menuName => text()();
  RealColumn get amount => real()();
  IntColumn get classfication => integer()();
  RealColumn get calories => real()();
  RealColumn get carbohydrate => real()();
  RealColumn get protein => real()();
  RealColumn get fat => real()();
  RealColumn get sodium => real()();
  RealColumn get sugar => real()();
}