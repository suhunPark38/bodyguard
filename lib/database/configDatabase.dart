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

  /* PersonalSettings 테이블 */

  /// 최초 로그인 시, 사용자 설정값 추가
  Future<void> insertPersonalSettings(PersonalSettingsCompanion entry) async{
    await into(personalSettings).insert(entry);
  }

  /// 사용자 설정값 수정
  Future<void> updatePersonalSettings(PersonalSettingsCompanion entry) async{
    await update(personalSettings).replace(entry);
  }

  /* DailyActivityInfo 테이블 */

  /// 일일 활동량 저장
  Future<void> insertDailyActivityInfo(DailyActivityInfoCompanion entry) async{
    await into(dailyActivityInfo).insert(entry);
  }

  /* DailyActivityDetail 테이블 */


  /* Diet 테이블 */

  /// Diet 테이블에 식단 추가하는 메소드
  Future<void> insertDiet(DietCompanion entry) async{
    await into(diet).insert(entry);
  }

  /// Diet 테이블에서 EatingTime으로 해당 날짜의 Diet 조회하는 메소드
  Future<List<DietData>> getDietByEatingTime(DateTime eatingTime) async {
    final DateTime startDate = DateTime(eatingTime.year, eatingTime.month, eatingTime.day);
    final DateTime endDate = startDate.add(Duration(days: 1));

    return await (select(diet)..where((tbl) => tbl.eatingTime.isBetweenValues(startDate, endDate))).get();
  }
}

LazyDatabase _openConnection(){
  return LazyDatabase(() async{
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return NativeDatabase(file);
  });
}











