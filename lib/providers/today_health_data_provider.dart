import 'package:flutter/material.dart';
import '../database/config_database.dart';

class TodayHealthDataProvider extends ChangeNotifier {
  double _todayTotalCalories = 0;
  String _mealTimeDetails = "";
  final double _todayTotalWaterIntake = 500.0;
  final double _bodyWeight = 70.0;
  final int _todayTotalStepCount = 4812;

  double get todayTotalCalories => _todayTotalCalories;
  String get mealTimeDetails => _mealTimeDetails;
  double get todayTotalWaterIntake => _todayTotalWaterIntake;
  double get bodyWeight => _bodyWeight;
  int get todayTotalStepCount => _todayTotalStepCount;

  TodayHealthDataProvider() {
    _initializeData();
  }

  // 데이터 초기화를 위한 비동기 함수
  Future<void> _initializeData() async {
    await fetchTodayTotalCalories(DateTime.now());
    getMealTime(DateTime.now());
    //추가
  }

  // 오늘의 총 칼로리를 가져오는 비동기 함수
  Future<void> fetchTodayTotalCalories(DateTime date) async {
    final database =  ConfigDatabase.instance;
    final totalCalories = await database.getTotalCaloriesForDate(date);
    _todayTotalCalories = totalCalories;
    notifyListeners();
  }

  void getMealTime(DateTime date){
    int hour = date.hour;

    if (hour >= 6 && hour < 12) {
      _mealTimeDetails =  '아침을 주문할까요?';
    } else if (hour >= 12 && hour < 17) {
      _mealTimeDetails =  '점심을 주문할까요?';
    } else if (hour >= 17 && hour < 22) {
      _mealTimeDetails =  '저녁을 주문할까요?';
    } else {
      _mealTimeDetails =  '메뉴를 주문할까요?';
    }

    notifyListeners();
  }
}
