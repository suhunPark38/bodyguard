import 'package:drift/drift.dart';

class Diet extends Table{
  IntColumn get dietId => integer().autoIncrement()();
  DateTimeColumn get eatingTime => dateTime()();
  TextColumn get menuName => text()();
  RealColumn get amount => real()();
  IntColumn get classfication => integer()();
  TextColumn get carbohydrate => text()();
  TextColumn get protein => text()();
  TextColumn get fat => text()();
  TextColumn get sodium => text()();
  TextColumn get sugar => text()();
}