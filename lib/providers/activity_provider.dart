import 'package:flutter/material.dart';
import '../model/activity_model.dart';
import '../services/activity_service.dart';

import '../database/activity_database_helper.dart';



class ActivityProvider with ChangeNotifier {
  final ActivityService _activityService = ActivityService();
  late ActivityData _activityData;

  ActivityData get activityData => _activityData;

  ActivityProvider() {
    fetchActivityData();
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




  Future<void> fetchActivityData() async {
    _activityData = (await _activityService.getActivityData()) as ActivityData;
    notifyListeners();
  }

  Future<void> updateActivityData(ActivityData data) async {
    await _activityService.updateActivityData(data);
    _activityData = data;
    notifyListeners();
  }

  Future<void> incrementSteps(int steps) async {
    _activityData = _activityData.updateSteps(steps);
    await _activityService.incrementSteps(steps);
    notifyListeners();
  }

  Future<void> addSteps() async {
    try {
      int currentSteps = await _activityService.getCurrentSteps();
      currentSteps++;
      await _activityService.incrementSteps(currentSteps);
      _activityData = _activityData.updateSteps(currentSteps);
      notifyListeners();
    } catch (error) {
      print(error);
    }
  }

// Add other methods if needed for updating specific activity values

}


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
    // 앱이 시작될 때마다 데이터를 가져오도록 합니다.
    fetchActivityData();
  }

  void fetchActivityData() {
    notifyListeners(); // 상태 업데이트를 알림
    _activityService.getActivityData().listen((data) {
      _activityData = data;

      notifyListeners(); // 상태 업데이트를 알림
    });
  }

  */

/*Future<void> addStep(int steps) async {
    _activityData = _activityData.copyWith(steps: _activityData.steps + steps);

    await incrementSteps(steps);

    notifyListeners();
  }*//*
  Future<void> addStep(int steps) async {
    _activityData = _activityData.updateSteps(_activityData.steps + 1);
    await incrementSteps(steps);
    notifyListeners();
  }

  Future<void> incrementSteps(int steps) async {
    try {
      await _activityService.incrementSteps(steps);
    } catch (error) {
      print(error);
    }
  }





}*/

/*Future<void> addSteps(int count) async {
    */ /*_activityData = _activityData.copyWith(steps: _activityData.steps + count);*/ /*
    _activityData = _activityData.updateSteps(_activityData.steps + count);

    await DatabaseHelper.insertSteps(_activityData.steps); // SQLite 데이터베이스에 저장


    notifyListeners();
  }*/

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

/*void fetchSteps() async {
    try {
      int steps = await _activityService.getCurrentSteps();
      _activityData = _activityData.copyWith(steps: steps);
      notifyListeners();
    } catch (error) {
      print(error);
    }
  }*/

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
