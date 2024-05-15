import 'package:flutter/material.dart';
import '../database/config_database.dart';

class TodayHealthDataProvider extends ChangeNotifier {
  double _todayTotalCalories = 0;
  final double _todayTotalWaterIntake = 500.0;
  final double _bodyWeight = 70.0;
  final int _todayTotalStepCount = 4812;

  double get todayTotalCalories => _todayTotalCalories;
  double get todayTotalWaterIntake => _todayTotalWaterIntake;
  double get bodyWeight => _bodyWeight;
  int get todayTotalStepCount => _todayTotalStepCount;

  TodayHealthDataProvider() {
    _initializeData();
  }

  // 데이터 초기화를 위한 비동기 함수
  Future<void> _initializeData() async {
    await fetchTodayTotalCalories(DateTime.now());
    //추가
  }

  // 오늘의 총 칼로리를 가져오는 비동기 함수
  Future<void> fetchTodayTotalCalories(DateTime date) async {
    final database =  ConfigDatabase.instance;
    final totalCalories = await database.getTotalCaloriesForDate(date);
    _todayTotalCalories = totalCalories;
    notifyListeners();
  }

}
