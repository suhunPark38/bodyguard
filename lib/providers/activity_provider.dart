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


}





