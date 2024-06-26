
import 'package:bodyguard/utils/health_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:health/health.dart';

class HealthDataProvider with ChangeNotifier {

  AppState _state = AppState.DATA_NOT_FETCHED; // 현재 health data 상태
  DateTime _selectedDate = DateTime.now(); // 가져올 건강 데이터 시간
  int _steps = 0;
  double _totalCalorieBurned = 0;
  double _water = 0;
  double _activeCalorieBurned = 0;
  double _height = 0;
  double _weight = 0;

  double _todayWater = 0;
  int _todayStep = 0;

  late double _targetCalorie = 0;

  double get targetCalorie => _targetCalorie;

  DateTime get selectedDate => _selectedDate;

  set selectedDate(DateTime date) {
    _selectedDate = DateTime(
      date.year,
      date.month,
      date.day,
      _selectedDate.hour,
      _selectedDate.minute,
      _selectedDate.second,
    );
  }
  AppState get state => _state;
  int get steps => _steps;

  double get height => _height;
  double get weight => _weight;
  double get totalCalorie => _totalCalorieBurned;
  double get water => _water;
  double get activeCalorieBurned => _activeCalorieBurned;
  double get todayWater => _todayWater;
  int get todayStep => _todayStep;

  bool get isToday {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    return _selectedDate.year == today.year &&
        _selectedDate.month == today.month &&
        _selectedDate.day == today.day;
  }

  set targetCalorie(double value) {
    _targetCalorie = value;
    notifyListeners();

  }

  HealthDataProvider() {
    fetchStepData(_selectedDate);
    fetchData(_selectedDate);
  }


  /// 기본 데이터 (신장, 몸무게 등) 가져오기
  Future<void> fetchData(DateTime date) async {
    _setNow();

    _state = AppState.FETCHING_DATA;

    final startTime = DateTime(date.year, date.month, date.day);
    final endTime = startTime.add(const Duration(hours: 23, minutes: 59));

    double totalCalories = 0;
    double totalActiveCalories = 0;
    double totalWater = 0;

    // try {
    // fetch health data
    List<HealthDataPoint> healthData = await Health().getHealthDataFromTypes(
      types: HealthUtil().types,
      startTime: startTime,
      endTime: endTime,
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
          totalCalories += value['numeric_value'] as double;
          break;
        case HealthDataType.WATER:
          print(value);
          totalWater += value['numeric_value'] as double;
          break;
        case HealthDataType.HEIGHT:
          _height = (value['numeric_value'] as double) * 100;
          break;
        case HealthDataType.WEIGHT:
          _weight = value['numeric_value'] as double;
          ;
          break;
        case HealthDataType.ACTIVE_ENERGY_BURNED:
          totalActiveCalories += (value['numeric_value'] as double);
        default:
          break;
      }
    }
    _totalCalorieBurned = totalCalories;
    _activeCalorieBurned = totalActiveCalories;
    _water = totalWater;

    if (selectedDate.day == DateTime.now().day){
      _todayWater = _water;
    }

    _state = healthData.isEmpty ? AppState.NO_DATA : AppState.DATA_READY;

      print(_state);
      notifyListeners();

  }

  void updateHeight(double? height){
    if(height != null) {
      _height = height;
      addHeightData(height);
      notifyListeners();
    }
  }
  void updateWeight(double? weight){
    if(weight != null) {
      _weight = weight;
      addWeightData(weight);
      notifyListeners();
    }
  }
  void updateTargetCalorie(double? targetCalorie){
    if(targetCalorie != null) {
      _targetCalorie = targetCalorie;
      notifyListeners();
    }
  }

  /// Fetch steps from the health plugin and show them in the app.
  Future<void> fetchStepData(DateTime date) async {
    _setNow();

    int? fetchedSteps;

    // get steps for today (i.e., since midnight)
    final midnight = DateTime(date.year, date.month, date.day);
    final end = midnight.add(Duration(hours: 23, minutes: 59));

    bool stepsPermission =
        await Health().hasPermissions([HealthDataType.STEPS]) ?? false;
    if (!stepsPermission) {
      stepsPermission =
          await Health().requestAuthorization([HealthDataType.STEPS]);
    }

    if (stepsPermission) {
      try {
        fetchedSteps = await Health().getTotalStepsInInterval(midnight, end);
      } catch (error) {
        debugPrint("Exception in getTotalStepsInInterval: $error");
      }

      debugPrint('Total number of steps: $steps');

      _steps = (fetchedSteps == null) ? 0 : fetchedSteps;
      _state = (fetchedSteps == null) ? AppState.NO_DATA : AppState.STEPS_READY;

      if (selectedDate.day == DateTime.now().day) {
        _todayStep = _steps;
      }
    } else {
      debugPrint("Authorization not granted - error in authorization");
      _state = AppState.DATA_NOT_FETCHED;
    }
    notifyListeners();
  }

  /// 걸음 수 데이터 추가
  Future<void> addStepData(double add) async {
    _setNow();

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
    _setNow();
    final now = _selectedDate;
    _height = add;
    // Add data for supported types
    // NOTE: These are only the ones supported on Androids new API Health Connect.
    // Both Android's Google Fit and iOS' HealthKit have more types that we support in the enum list [HealthDataType]
    // Add more - like AUDIOGRAM, HEADACHE_SEVERE etc. to try them.
    bool success = true;

    // misc. health data examples using the writeHealthData() method
    success &= await Health().writeHealthData(
        value: add /100,
        type: HealthDataType.HEIGHT,
        startTime: now);

    _state = success ? AppState.DATA_ADDED : AppState.DATA_NOT_ADDED;


    notifyListeners();
  }

  /// 몸무게 데이터 추가
  Future<void> addWeightData(double add) async {
    _setNow();
    final now = _selectedDate;
    _weight = add;
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
    _setNow();
    final now = _selectedDate;
    final earlier = now.subtract(Duration(seconds: 1));

    bool success = true;

   // misc. health data examples using the writeHealthData() method
    success &= await Health().writeHealthData(
        value: add,
        type: HealthDataType.WATER,
        startTime: earlier,
        endTime: now);

    _state = success ? AppState.DATA_ADDED : AppState.DATA_NOT_ADDED;

    fetchData(now);

    print(_state);
    notifyListeners();
  }

  /// selectedDate의 시, 분, 초 값을 현재 시간에 맞게 동기화
  void _setNow() {
    final now = DateTime.now();
    _selectedDate = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      now.hour,
      now.minute,
      now.second,
    );
  }

  void postFetchData(DateTime date){
    _selectedDate = date;
    fetchData(_selectedDate);
    fetchStepData(_selectedDate);
  }


  /// 전날로 이동
  void previousDate() {
    _setNow();
    _selectedDate = _selectedDate.subtract(Duration(days: 1));
    fetchStepData(_selectedDate);
    fetchData(_selectedDate);
  }

  /// 다음날로 이동
  void nextDate() {
    _setNow();
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    if (_selectedDate.isBefore(today)) {
      _selectedDate = _selectedDate.add(Duration(days: 1));
      fetchStepData(_selectedDate);
      fetchData(_selectedDate);
      notifyListeners();
    }
  }

  /// 오늘로 이동
  void todayDate() {
    _selectedDate = DateTime.now();
    fetchStepData(_selectedDate);
    fetchData(_selectedDate);
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

