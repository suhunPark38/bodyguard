import 'package:bodyguard/model/diet.dart';
import 'package:bodyguard/model/personalSettings.dart';
import 'package:bodyguard/model/dailyActivityInfo.dart';
import 'package:bodyguard/model/dailyActivityDetail.dart';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'dart:io';



part 'configDatabase.g.dart';


/// localdb 관리 클래스
@DriftDatabase(
  tables: [
    Diet,
    PersonalSettings,
    DailyActivityInfo,
    DailyActivityDetail,
  ],
)
class ConfigDatabase extends _$configDatabase {
  ConfigDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;
}

LazyDatabase _openConnection(){
  return LazyDatabase(() async{
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return NativeDatabase(file);
  });
}











