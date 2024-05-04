import 'package:cloud_firestore/cloud_firestore.dart';

class ActivityService {
  Future<void> updateActivityData(Map<String, dynamic> data) async {
    try {
      await FirebaseFirestore.instance
          .collection('activity_data')
          .doc('user_activity')
          .set(data);
    } catch (error) {
      print(error); // 디버깅을 위해 오류 출력
      // 여기에 사용자에게 오류 메시지를 표시하는 코드를 추가할 수 있습니다.
    }
  }

  Future<void> incrementSteps(int steps) async {
    try {
      await FirebaseFirestore.instance
          .collection('step_count')
          .doc('user_steps')
          .update({'steps': steps});
    } catch (error) {
      print(error); // 디버깅을 위해 오류 출력
      // 여기에 사용자에게 오류 메시지를 표시하는 코드를 추가할 수 있습니다.
    }
  }
}
