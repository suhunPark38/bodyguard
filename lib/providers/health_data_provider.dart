import 'package:flutter/cupertino.dart';
import 'package:health/health.dart';

class HealthDataProvider with ChangeNotifier {

  AppState _state = AppState.DATA_NOT_FETCHED;
  int _nofSteps = 0;



  /// Fetch steps from the health plugin and show them in the app.
  Future<void> fetchStepData() async {
    int? steps;

    // get steps for today (i.e., since midnight)
    final now = DateTime.now();
    final midnight = DateTime(now.year, now.month, now.day);

    bool stepsPermission =
        await Health().hasPermissions([HealthDataType.STEPS]) ?? false;
    if (!stepsPermission) {
      stepsPermission =
      await Health().requestAuthorization([HealthDataType.STEPS]);
    }

    if (stepsPermission) {
      try {
        steps = await Health().getTotalStepsInInterval(midnight, now);
      } catch (error) {
        debugPrint("Exception in getTotalStepsInInterval: $error");
      }

      debugPrint('Total number of steps: $steps');


        _nofSteps = (steps == null) ? 0 : steps;
        _state = (steps == null) ? AppState.NO_DATA : AppState.STEPS_READY;

    } else {
      debugPrint("Authorization not granted - error in authorization");
      _state = AppState.DATA_NOT_FETCHED;
    }
  }

}

enum AppState {
  DATA_NOT_FETCHED,
  FETCHING_DATA,
  DATA_READY,
  NO_DATA,
  AUTHORIZED,
  AUTH_NOT_GRANTED,
  DATA_ADDED,
  DATA_DELETED,
  DATA_NOT_ADDED,
  DATA_NOT_DELETED,
  STEPS_READY,
  HEALTH_CONNECT_STATUS,
}


