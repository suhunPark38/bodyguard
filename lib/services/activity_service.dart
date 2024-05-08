import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/activity_model.dart';

class ActivityService {
  double weight = 70; // weight 변수 정의
  double bikingSpeed = 2.5; // bikingSpeed 변수 정의
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> updateActivityData(ActivityData data) async {
    try {
      await _firestore.collection('activity_data').doc('user_activity').set(
        {
          'weight': data.weight,
          'runningTime': data.runningTime,
          'caloriesBurned': data.caloriesBurned,
          'bikingTime': data.bikingTime,
          'BcaloriesBurned': data.BcaloriesBurned,
          'steps': data.steps,
        },
        SetOptions(merge: true), // merge 옵션을 사용하여 기존 데이터와 병합
      );
    } catch (error) {
      print(error);
    }
  }

  Stream<ActivityData> getActivityData() {
    return _firestore
        .collection('activity_data')
        .doc('user_activity')
        .snapshots()
        .map((snapshot) => ActivityData(
      weight: snapshot['weight'] ?? 70,
      runningTime: snapshot['runningTime'] ?? 0,
      caloriesBurned: snapshot['caloriesBurned'] ?? 0,
      bikingTime: snapshot['bikingTime'] ?? 0,
      BcaloriesBurned: snapshot['BcaloriesBurned'] ?? 0,
      steps: snapshot['steps'] ?? 0,
    ));
  }


  Future<void> incrementSteps(int steps) async {
    try {
      await _firestore.collection('step_count').doc('user_steps').set(
        {'steps': steps},
        SetOptions(merge: true), // merge 옵션을 사용하여 기존 데이터와 병합
      );
    } catch (error) {
      print(error);
    }
  }
  Future<int> getCurrentSteps() async {
    try {
      // Firebase에서 사용자의 걸음 수를 가져오는 코드
      DocumentSnapshot snapshot =
      await _firestore.collection('step_count').doc('user_steps').get();
      int currentSteps = snapshot['steps'] ?? 0;
      return currentSteps;
    } catch (error) {
      print(error);
      return 0; // 에러 발생 시 기본값으로 0을 반환
    }
  }




  void updateRunningValues(double runningTime) async {
    try {
      // 달리기 데이터를 업데이트합니다.
      await _firestore.collection('activity_data').doc('user_activity').set(
        {
          'weight': weight,
          'runningTime': runningTime,
          'caloriesBurned': weight * runningTime / 60 * 3.5,
        },
        SetOptions(merge: true),
      );
    } catch (error) {
      print(error);
    }

    _firestore.collection('runningData').add({
      'runningTime': runningTime,
      'timestamp': DateTime.now(),
    });
  }

  void updateBikingValues(double bikingTime) async {
    try {
      // 자전거 데이터를 업데이트합니다.
      await _firestore.collection('activity_data').doc('user_activity').set(
        {

          'bikingTime': bikingTime,
          'BcaloriesBurned':  bikingTime * bikingSpeed / 60 * 4.0,
        },
        SetOptions(merge: true),
      );
    } catch (error) {
      print(error);
    }

    _firestore.collection('bikingData').add({
      'bikingTime': bikingTime,
      'timestamp': DateTime.now(),
    });
  }

  void addSteps() async {
    try {
      // 현재 사용자의 단계 수를 가져옵니다.
      int currentSteps = await getCurrentSteps();

      // 단계 수를 증가시킵니다.
      currentSteps++;

      // 단계 수를 업데이트합니다.
      await _firestore.collection('activity_data').doc('user_activity').set(
        {
          'steps': currentSteps,
        },
        SetOptions(merge: true),
      );
    } catch (error) {
      print(error);
    }
  }



 /*



void updateValues(double running, double biking) async {
    try {
      // 활동 데이터를 업데이트합니다.
      await _firestore.collection('activity_data').doc('user_activity').set(
        {
          'weight': weight,
          'runningTime': running,
          'caloriesBurned': weight * running / 60 * 3.5,
          'bikingTime': biking,
          'BcaloriesBurned': weight * biking * bikingSpeed / 60 * 4.0,
        },
        SetOptions(merge: true), // merge 옵션을 사용하여 기존 데이터와 병합
      );
    } catch (error) {
      print(error);
    }
  }*/
}
