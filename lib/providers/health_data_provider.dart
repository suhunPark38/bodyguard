import 'package:bodyguard/utils/health_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:health/health.dart';

class HealthDataProvider with ChangeNotifier {

  AppState _state = AppState.DATA_NOT_FETCHED;
  int _steps = 0;
  double _height = 0;
  double _weight = 0;
  double _totalCalorie = 0;
  double _water = 0;

  int get state => state;
  int get steps => _steps;
  double get height => _height;
  double get weight => _weight;
  double get totalCalorie => _totalCalorie;
  double get water => _water;

  HealthDataProvider(){
    fetchStepData(DateTime.now());
    fetchData(DateTime.now());
  }

  /// Fetch data points from the health plugin and show them in the app.
  Future<void> fetchData(DateTime date) async {
    _state = AppState.FETCHING_DATA;

    // get data within the last 24 hours
    final now = date;
    final yesterday = now.subtract(Duration(hours: 24));


    // try {
    // fetch health data
    List<HealthDataPoint> healthData = await Health().getHealthDataFromTypes(
      types: HealthUtil().types,
      startTime: yesterday,
      endTime: now,
    );

    debugPrint('Total number of data points: ${healthData.length}. '
        '${healthData.length > 100 ? 'Only showing the first 100.' : ''}');


    // filter out duplicates
    healthData = Health().removeDuplicates(healthData);

    // Iterate through healthData to populate fields
    for (var dataPoint in healthData) {
      switch (dataPoint.type) {
        case HealthDataType.TOTAL_CALORIES_BURNED:
          final value = dataPoint.value.toJson();
          _totalCalorie = value['numeric_value'] as double;
          break;
        case HealthDataType.HEIGHT:
          final value = dataPoint.value.toJson();
          _height = value['numeric_value'] as double;
          break;
        case HealthDataType.WEIGHT:
          final value = dataPoint.value.toJson();
          _weight = value['numeric_value'] as double;;
          break;
        case HealthDataType.WATER:
          final value = dataPoint.value.toJson();
          _water = (value['numeric_value'] as double);
          break;
        default:
          break;
      }
    }


      _state = healthData.isEmpty ? AppState.NO_DATA : AppState.DATA_READY;

    print(_state);
    notifyListeners();
  }


  /// Fetch steps from the health plugin and show them in the app.
  Future<void> fetchStepData(DateTime date) async {
    int? fetchedSteps;


    // get steps for today (i.e., since midnight)
    final now = date;
    final midnight = DateTime(now.year, now.month, now.day);

    bool stepsPermission =
        await Health().hasPermissions([HealthDataType.STEPS]) ?? false;
    if (!stepsPermission) {
      stepsPermission =
      await Health().requestAuthorization([HealthDataType.STEPS]);
    }

    if (stepsPermission) {
      try {
        fetchedSteps = await Health().getTotalStepsInInterval(midnight, now);
      } catch (error) {
        debugPrint("Exception in getTotalStepsInInterval: $error");
      }

      debugPrint('Total number of steps: $steps');


        _steps = (fetchedSteps == null) ? 0 : fetchedSteps;
        _state = (fetchedSteps == null) ? AppState.NO_DATA : AppState.STEPS_READY;

    } else {
      debugPrint("Authorization not granted - error in authorization");
      _state = AppState.DATA_NOT_FETCHED;
    }
    notifyListeners();
  }

  /// 걸음 수 데이터 추가
  Future<void> addStepData(double add) async {
    final now = DateTime.now();
    final earlier = now.subtract(Duration(minutes: 20));

    // Add data for supported types
    // NOTE: These are only the ones supported on Androids new API Health Connect.
    // Both Android's Google Fit and iOS' HealthKit have more types that we support in the enum list [HealthDataType]
    // Add more - like AUDIOGRAM, HEADACHE_SEVERE etc. to try them.
    bool success = true;

    // misc. health data examples using the writeHealthData() method
    success &= await Health().writeHealthData(
        value: add,
        type: HealthDataType.STEPS,
        startTime: earlier,
        endTime: now);

      _state = success ? AppState.DATA_ADDED : AppState.DATA_NOT_ADDED;

      print(_state);
      notifyListeners();
  }

  /// 신장(키) 데이터 추가
  Future<void> addHeightData(double add) async {
    final now = DateTime.now();
    final earlier = now.subtract(Duration(minutes: 20));

    // Add data for supported types
    // NOTE: These are only the ones supported on Androids new API Health Connect.
    // Both Android's Google Fit and iOS' HealthKit have more types that we support in the enum list [HealthDataType]
    // Add more - like AUDIOGRAM, HEADACHE_SEVERE etc. to try them.
    bool success = true;

    // misc. health data examples using the writeHealthData() method
    success &= await Health().writeHealthData(
        value: add,
        type: HealthDataType.HEIGHT,
        startTime: earlier,
        endTime: now);

    _state = success ? AppState.DATA_ADDED : AppState.DATA_NOT_ADDED;
    notifyListeners();
  }

  /// 몸무게 데이터 추가
  Future<void> addWeightData(double add) async {
    final now = DateTime.now();

    // Add data for supported types
    // NOTE: These are only the ones supported on Androids new API Health Connect.
    // Both Android's Google Fit and iOS' HealthKit have more types that we support in the enum list [HealthDataType]
    // Add more - like AUDIOGRAM, HEADACHE_SEVERE etc. to try them.
    bool success = true;

    // misc. health data examples using the writeHealthData() method
    success &= await Health().writeHealthData(
        value: add,
        type: HealthDataType.WEIGHT,
        startTime: now);

    _state = success ? AppState.DATA_ADDED : AppState.DATA_NOT_ADDED;
    notifyListeners();
  }

  /// 물 섭취 데이터 추가
  Future<void> addWaterData(double add) async {
    final now = DateTime.now();
    final earlier = now.subtract(Duration(minutes: 20));

    _water += add;

    // Add data for supported types
    // NOTE: These are only the ones supported on Androids new API Health Connect.
    // Both Android's Google Fit and iOS' HealthKit have more types that we support in the enum list [HealthDataType]
    // Add more - like AUDIOGRAM, HEADACHE_SEVERE etc. to try them.
    bool success = true;

    // misc. health data examples using the writeHealthData() method
    success &= await Health().writeHealthData(
        value: _water,
        type: HealthDataType.WATER,
        startTime: earlier,
        endTime: now);

    _state = success ? AppState.DATA_ADDED : AppState.DATA_NOT_ADDED;

    print(_state);
    notifyListeners();
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

enum ExerciseData {
  running(1.5, 600),
  cycling(2.0, 500),
  swimming(1.0, 700),
  walking(1.0, 200),
  weightTraining(1.0, 400);

  final double runningTime;
  final double burnedCaloriePerHour;
  const ExerciseData(this.runningTime, this.burnedCaloriePerHour);

  double get totalBurnedCalories => runningTime * burnedCaloriePerHour;
}

