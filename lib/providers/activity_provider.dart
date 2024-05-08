import 'package:flutter/material.dart';
import '../model/activity_model.dart';
import '../services/activity_service.dart';

import '../database/activity_database_helper.dart';

class ActivityProvider extends ChangeNotifier {
  final ActivityService _activityService = ActivityService();
  late ActivityData _activityData;
  bool _isLoading = false; // 로딩 상태를 나타내는 변수 추가

  ActivityData get activityData => _activityData;
  bool get isLoading => _isLoading; // 로딩 상태를 확인하는 getter 추가

  ActivityProvider() {
    _activityData = ActivityData(
      weight: 70,
      runningTime: 0,
      caloriesBurned: 0,
      bikingTime: 0,
      BcaloriesBurned: 0,
      steps: 0,
    );
    // 앱이 시작될 때마다 데이터를 가져오도록 합니다.
    fetchActivityData();
  }

  void fetchActivityData() {
    _isLoading = true; // 데이터 가져오기 시작 시 로딩 상태를 true로 설정
    notifyListeners(); // 상태 업데이트를 알림
    _activityService.getActivityData().listen((data) {
      _activityData = data;
      _isLoading = false; // 데이터 가져오기 완료 시 로딩 상태를 false로 설정
      notifyListeners(); // 상태 업데이트를 알림
    });
  }

  Future<void> addSteps(int count) async {
    /*_activityData = _activityData.copyWith(steps: _activityData.steps + count);*/
    _activityData = _activityData.updateSteps(_activityData.steps + count);

    await DatabaseHelper.insertSteps(_activityData.steps); // SQLite 데이터베이스에 저장


    notifyListeners();
  }

  /*Future<void> getStoredSteps() async {
    final storedSteps = await DatabaseHelper.getSteps();
    if (storedSteps != null) {
      _activityData = _activityData.copyWith(steps: storedSteps);
      notifyListeners();
    }
  }*/


  /*void addSteps(int stepsToAdd) {
    _activityData = _activityData.copyWith(steps: _activityData.steps + stepsToAdd);
    notifyListeners();
  }*/

  void incrementSteps(int steps) async {
    try {
      await _activityService.incrementSteps(steps);
    } catch (error) {
      print(error);
    }
  }

  /*void fetchSteps() async {
    try {
      int steps = await _activityService.getCurrentSteps();
      _activityData = _activityData.copyWith(steps: steps);
      notifyListeners();
    } catch (error) {
      print(error);
    }
  }*/
}


/*
void addSteps(int stepsToAdd) {
    _activityData = _activityData.copyWith(steps: _activityData.steps + stepsToAdd);
    notifyListeners();
  }

*/






/*class ActivityProvider extends ChangeNotifier {
  final ActivityService _activityService = ActivityService();
  late ActivityData _activityData;

  ActivityData get activityData => _activityData;

  ActivityProvider() {
    _activityData = ActivityData(
      weight: 70,
      runningTime: 0,
      caloriesBurned: 0,
      bikingTime: 0,
      BcaloriesBurned: 0,
      steps: 0,
    );
    fetchActivityData();
  }

  void updateActivityData(ActivityData newData) async {
    await _activityService.updateActivityData(newData);
    _activityData = newData;
    notifyListeners();
  }

  void fetchActivityData() {
    _activityService.getActivityData().listen((data) {
      _activityData = data;
      notifyListeners();
    });
  }
}*/
