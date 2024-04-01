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
class ConfigDatabase extends _$ConfigDatabase {
  ConfigDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  /// Diet 테이블에 식단 추가하는 메소드
  Future<void> insertDiet(DietCompanion entry) async{
    await into(diet).insert(entry);
  }

  /// Diet 테이블에서 EatingTime으로 해당 날짜의 Diet 조회하는 메소드
  Future<List<DietData>> getDietByEatingTime(DateTime eatingTime){
    final DateTime startDate = DateTime(eatingTime.year, eatingTime.month, eatingTime.day);
    final DateTime endDate = startDate.add(Duration(days: 1));

    return (select(diet)..where((tbl) => tbl.eatingTime.isBetweenValues(startDate, endDate))).get();
  }
}

LazyDatabase _openConnection(){
  return LazyDatabase(() async{
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return NativeDatabase(file);
  });
}











