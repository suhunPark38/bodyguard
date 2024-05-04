import 'package:flutter/material.dart';
import '../database/config_database.dart';

class HealthDataProvider extends ChangeNotifier {
  double _todayTotalCalories = 0;
  String _mealTimeDetails = "";
  //double _waterIntake = 0;
  //double _bodyWeight = 0;
  //int _stepCount = 0;s

  double get todayTotalCalories => _todayTotalCalories;
  String get mealTimeDetails => _mealTimeDetails;
  //double get waterIntake => _waterIntake;
  //double get bodyWeight => _bodyWeight;
  //int get stepCount => _stepCount;

  HealthDataProvider() {
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

    if (hour >= 7 && hour < 12) {
      _mealTimeDetails =  '아침을 주문할까요?';
    } else if (hour >= 12 && hour < 18) {
      _mealTimeDetails =  '점심을 주문할까요?';
    } else if (hour >= 18 && hour < 22) {
      _mealTimeDetails =  '저녁을 주문할까요?';
    } else {
      _mealTimeDetails =  '메뉴를 주문할까요?';
    }

    notifyListeners();
  }
}
