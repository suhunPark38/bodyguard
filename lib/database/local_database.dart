import 'package:bodyguard/model/diet.dart';
import 'package:bodyguard/model/personal_settings.dart';
import 'package:bodyguard/model/daily_activity_info.dart';
import 'package:bodyguard/model/daily_activity_detail.dart';
import 'package:bodyguard/model/search_history.dart';
import 'package:bodyguard/model/selected_menu.dart';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'dart:io';

part 'local_database.g.dart';

// local db 관리 클래스
@DriftDatabase(
  tables: [
    Diet,
    PersonalSettings,
    DailyActivityInfo,
    DailyActivityDetail,
    SearchHistory,
    SelectedMenu
  ],
)
class LocalDatabase extends _$LocalDatabase {
  static LocalDatabase _instance = LocalDatabase._(); // 초기화

  static LocalDatabase get instance {
    return _instance;
  }

  // 싱글톤 패턴을 위한 private 생성자
  LocalDatabase._() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  /*SelectedMenus table*/

  /// 메뉴 항목을 쇼핑 카트에 추가하거나 이미 존재하는 경우 수량 업데이트
  Future<void> insertOrUpdateMenu(String storeId, String menuId, int quantity) async {
    await into(selectedMenu).insertOnConflictUpdate(
      SelectedMenuCompanion.insert(
        storeId: storeId,
        menuId: menuId,
        quantity: quantity,
      ),
    );
  }

  /// 쇼핑 카트에 담긴 모든 메뉴 항목 조회
  Future<List<SelectedMenuData>> getSelectedMenus() async {
    return await select(selectedMenu).get();
  }


  /// 특정 메뉴 항목의 수량 업데이트
  Future<void> updateMenuQuantity(String menuId, int newQuantity) async {
    await (update(selectedMenu)..where((tbl) => tbl.menuId.equals(menuId)))
        .write(SelectedMenuCompanion(quantity: Value(newQuantity)));
  }

  /// 특정 메뉴 항목 삭제
  Future<void> removeMenu(String menuId) async {
    await (delete(selectedMenu)..where((tbl) => tbl.menuId.equals(menuId))).go();
  }

  /// 쇼핑 카트 비우기 (모든 메뉴 항목 삭제)
  Future<void> clearData() async {
    await delete(selectedMenu).go();
  }

  /*SearchHistory table*/
  /// 검색어 삽입
  Future<void> insertSearch(String search) async {
    await into(searchHistory).insert(SearchHistoryCompanion(
      search: Value(search),
    ));
  }

  /// 검색 기록 조회
  Future<List<String>> getSearchHistory() async {
    final results = await select(searchHistory).get();
    return results.map((row) => row.search).toList();
  }

  /// 특정 검색어 삭제
  Future<void> deleteSearch(String search) async {
    await (delete(searchHistory)..where((tbl) => tbl.search.equals(search))).go();
  }

  /// 전체 검색 기록 삭제
  Future<void> clearAllSearches() async {
    await delete(searchHistory).go();
  }


  /* Diet 테이블 */

  /// Diet 테이블에 식단 추가하는 메소드
  Future<void> insertDiet(DietCompanion entry) async {
    await into(diet).insert(entry);
  }

  /// Diet 테이블에서 EatingTime으로 해당 날짜의 Diet 조회하는 메소드
  Future<List<DietData>> getDietByEatingTime(DateTime eatingTime) async {
    final DateTime startDate =
        DateTime(eatingTime.year, eatingTime.month, eatingTime.day);
    final DateTime endDate = startDate.add(const Duration(
        hours: 23, minutes: 59)); // 조회 시간을 00시 00분 ~ 23시 59분까지로 설정

    return await (select(diet)
          ..where((tbl) => tbl.eatingTime.isBetweenValues(startDate, endDate)))
        .get();
  }

  /// Diet 테이블에서 startDate ~ endDate까지 Diet 조회하는 메소드
  Future<List<DietData>> getDietBetweenDates(
      DateTime startDate, DateTime endDate) async {
    return (select(diet)
      ..where((d) => d.eatingTime.isBetweenValues(startDate, endDate)))
        .get();
  }

  // Diet 테이블 레코드 수정
  Future updateDiet(DietCompanion entry, int dietId) async {
    return update(diet)
      ..where((tbl) => tbl.dietId.equals(dietId))
      ..write(entry);
  }

  /// Diet 테이블에서 레코드 삭제
  Future<void> deleteDiet(int dietId) async {
    await (delete(diet)..where((d) => d.dietId.equals(dietId))).go();
  }

  /// 특정 날짜의 총 칼로리 계산
  Future<double> getTotalCaloriesForDate(DateTime date) async {
    final List<DietData> diets = await getDietByEatingTime(date);

    double totalCalories = 0;
    for (final dietData in diets) {
      totalCalories += dietData.calories;
    }
    return totalCalories;
  }
  // 특정 기간의 아침들을 조회하는 메소드
  Future<List<DietData>> getBreakfastForPeriod(DateTime start, DateTime end) async {
    return await (select(diet)
      ..where((tbl) =>
      tbl.classification.equals(0) // 아침 정보만 필터링
      & tbl.eatingTime.isBetweenValues(start, end))) // 기간 필터링
        .get();
  }
  // 특정 기간의 점심들을 조회하는 메소드
  Future<List<DietData>> getLunchForPeriod(DateTime start, DateTime end) async {
    return await (select(diet)
      ..where((tbl) =>
      tbl.classification.equals(1) // 점심 정보만 필터링
      & tbl.eatingTime.isBetweenValues(start, end))) // 기간 필터링
        .get();
  }
  // 특정 기간의 저녁들을 조회하는 메소드
  Future<List<DietData>> getDinnerForPeriod(DateTime start, DateTime end) async {
    return await (select(diet)
      ..where((tbl) =>
      tbl.classification.equals(2) // 저녁 정보만 필터링
      & tbl.eatingTime.isBetweenValues(start, end))) // 기간 필터링
        .get();
  }

}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'local_database.sqlite'));
    return NativeDatabase(file);
  });
}
