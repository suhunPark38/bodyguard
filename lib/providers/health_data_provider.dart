import 'package:bodyguard/utils/health_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:health/health.dart';

class HealthDataProvider with ChangeNotifier {

  AppState _state = AppState.DATA_NOT_FETCHED; // 현재 health data 상태
  DateTime _selectedDate = DateTime.now(); // 가져올 건강 데이터 시간
  int _steps = 0;
  double _height = 0;
  double _weight = 0;
  double _totalCalorieBurned = 0;
  double _water = 0;
  double _activeCalorieBurned = 0;

  DateTime get selectedDate => _selectedDate;
  int get state => state;
  int get steps => _steps;
  double get height => _height;
  double get weight => _weight;
  double get totalCalorie => _totalCalorieBurned;
  double get water => _water;
  double get activeCalorieBurned => _activeCalorieBurned;

  HealthDataProvider(){
    fetchStepData(_selectedDate);
    fetchData(_selectedDate);
    fetchWaterData();
  }

  /// 기본 데이터 (신장, 몸무게 등) 가져오기
  Future<void> fetchData(DateTime date) async {
    _state = AppState.FETCHING_DATA;

    final now = date;
    final endTime = DateTime(now.year, now.month, now.day);


    // try {
    // fetch health data
    List<HealthDataPoint> healthData = await Health().getHealthDataFromTypes(
      types: HealthUtil().types,
      startTime: endTime,
      endTime: now,
    );

    debugPrint('Total number of data points: ${healthData.length}. '
        '${healthData.length > 100 ? 'Only showing the first 100.' : ''}');


    // filter out duplicates
    healthData = Health().removeDuplicates(healthData);

    // Iterate through healthData to populate fields
    for (var dataPoint in healthData) {
      final value = dataPoint.value.toJson();
      switch (dataPoint.type) {
        case HealthDataType.TOTAL_CALORIES_BURNED:
          final value = dataPoint.value.toJson();
          _totalCalorieBurned = value['numeric_value'] as double;
          print(_totalCalorieBurned);
          break;
        case HealthDataType.HEIGHT:
          _height = value['numeric_value'] as double;
          break;
        case HealthDataType.WEIGHT:
          _weight = value['numeric_value'] as double;;
          break;
        case HealthDataType.ACTIVE_ENERGY_BURNED:
          _activeCalorieBurned = (value['numeric_value'] as double);
          print(_activeCalorieBurned);
        default:
          break;
      }
    }

      _state = healthData.isEmpty ? AppState.NO_DATA : AppState.DATA_READY;

    print(_state);
    notifyListeners();
  }

  /// 마신 물 데이터 가져오기
  Future<void> fetchWaterData() async {
    _state = AppState.FETCHING_DATA;

    final now = _selectedDate;
    final endTime = DateTime(now.year, now.month, now.day);

    // fetch health data
    List<HealthDataPoint> healthData = await Health().getHealthDataFromTypes(
      types: [HealthDataType.WATER],
      startTime: endTime,
      endTime: now,
    );

    double totalWater = 0;
    for (var dataPoint in healthData) {
      final value = dataPoint.value.toJson();
      totalWater += value['numeric_value'] as double;
    }
    _water = totalWater;

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
    final now = _selectedDate;
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
    final now = _selectedDate;
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
    final now = _selectedDate;

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
    final now = _selectedDate;
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

  /// 전날로 이동
  void previousDate() {
    _selectedDate = _selectedDate.subtract(Duration(days: 1));
    fetchStepData(_selectedDate);
    fetchData(_selectedDate);
    fetchWaterData();
    notifyListeners();
  }

  /// 다음날로 이동
  void nextDate() {
    _selectedDate = _selectedDate.add(Duration(days: 1));
    fetchStepData(_selectedDate);
    fetchData(_selectedDate);
    fetchWaterData();
    notifyListeners();
  }

  /// 오늘로 이동
  void todayDate() {
    _selectedDate = DateTime.now();
    fetchStepData(_selectedDate);
    fetchData(_selectedDate);
    fetchWaterData();
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

