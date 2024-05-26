import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:health/health.dart';
import 'package:permission_handler/permission_handler.dart';

class HealthDataProvider with ChangeNotifier {

  AppState _state = AppState.DATA_NOT_FETCHED; // 현재 health data 상태
  DateTime _selectedDate = DateTime.now(); // 가져올 건강 데이터 시간
  int _steps = 0;
  double _height = 0;
  double _weight = 0;
  double _totalCalorieBurned = 0;
  double _water = 0;
  double _activeCalorieBurned = 0;

  double _todayWater = 0;
  int _todayStep = 0;

  DateTime get selectedDate => _selectedDate;
  AppState get state => _state;
  int get steps => _steps;
  double get height => _height;
  double get weight => _weight;
  double get totalCalorie => _totalCalorieBurned;
  double get water => _water;
  double get activeCalorieBurned => _activeCalorieBurned;
  double get todayWater => _todayWater;
  int get todayStep => _todayStep;

  HealthDataProvider() {
    Health().configure(useHealthConnectIfAvailable: true);

    fetchStepData(_selectedDate);
    fetchData(_selectedDate);
  }

  Future<void> authorize() async {
    await Permission.activityRecognition.request();
    await Permission.location.request();

    // Check if we have health permissions
    bool? hasPermissions =
    await Health().hasPermissions(types, permissions: permissions);

    // hasPermissions = false because the hasPermission cannot disclose if WRITE access exists.
    // Hence, we have to request with WRITE as well.
    hasPermissions = false;

    if (!hasPermissions) {
      // requesting access to the data types before reading them
      try {
        await Health()
            .requestAuthorization(types, permissions: permissions);
      } catch (error) {
        debugPrint("Exception in authorize: $error");
      }
    }

  }

  /// google health connect 설치
  Future<void> installHealthConnect() async {
    bool isAvailable = Health().useHealthConnectIfAvailable;

    //health connect를 사용할 수 없다면 (설치 되지 않았다면) 설치한다.
    if(!isAvailable && Platform.isAndroid){
      await Health().installHealthConnect();
    }
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
        types: types,
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
            _height = value['numeric_value'] as double;
            break;
          case HealthDataType.WEIGHT:
            _weight = value['numeric_value'] as double;;
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

        if (selectedDate.day == DateTime.now().day){
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
    _setNow();
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
  void _setNow(){
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
    _selectedDate = _selectedDate.add(Duration(days: 1));
    fetchStepData(_selectedDate);
    fetchData(_selectedDate);
  }

  /// 오늘로 이동
  void todayDate() {
    _selectedDate = DateTime.now();
    fetchStepData(_selectedDate);
    fetchData(_selectedDate);
  }

  // 안드로이드는 google health connect, ios는 apple health를 사용하기에 dataType 분리
  List<HealthDataType> get types => (Platform.isAndroid)
      ? dataTypesAndroid
      : (Platform.isIOS)
      ? dataTypesIOS
      : [];

  // Set up corresponding permissions
  // READ only
  List<HealthDataAccess> get permissions =>
      types.map((e) => HealthDataAccess.READ_WRITE).toList();


  // 안드로이드에서 사용하는 dataType
  get dataTypesAndroid => [
    HealthDataType.ACTIVE_ENERGY_BURNED,
    HealthDataType.TOTAL_CALORIES_BURNED,
    HealthDataType.STEPS,
    HealthDataType.HEIGHT,
    HealthDataType.WEIGHT,
    HealthDataType.WATER
  ];

  // IOS에서 사용하는 dataType
  get dataTypesIOS => [
    HealthDataType.ACTIVE_ENERGY_BURNED,
    HealthDataType.TOTAL_CALORIES_BURNED,
    HealthDataType.STEPS,
    HealthDataType.HEIGHT,
    HealthDataType.WEIGHT,
    HealthDataType.WATER
  ];


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

