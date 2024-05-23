import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:health/health.dart';
import 'package:permission_handler/permission_handler.dart';

/// Health 연동 관련 관련한 유틸 함수 모음
class HealthUtil {
  static final HealthUtil _instance = HealthUtil._internal();

  factory HealthUtil(){
    return _instance;
  }

  HealthUtil._internal();

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
    HealthDataType.TOTAL_CALORIES_BURNED,
    HealthDataType.STEPS,
    HealthDataType.HEIGHT,
    HealthDataType.WEIGHT,
    HealthDataType.WATER
  ];

  /// Authorize, i.e. get permissions to access relevant health data.
  Future<void> authorize() async {
    // If we are trying to read Step Count, Workout, Sleep or other data that requires
    // the ACTIVITY_RECOGNITION permission, we need to request the permission first.
    // This requires a special request authorization call.
    //
    // The location permission is requested for Workouts using the Distance information.
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