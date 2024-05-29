import 'package:drift/drift.dart';

class SelectedMenu extends Table{
  IntColumn get id => integer().autoIncrement()();
  TextColumn get storeId => text()();
  TextColumn get menuId => text()();
  IntColumn get quantity => integer()();
}