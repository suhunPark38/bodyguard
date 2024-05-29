import 'package:bodyguard/model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';

import 'auth_service.dart';

class UserFirebase {
  final FirebaseFirestore _firebase = FirebaseFirestore.instance;

  Future<String?> createUserInfo(
      {required uid, required UserInfoModel user}) async {
    try {
      await _firebase
          .collection('users')
          .doc(uid)
          .set(user.toJson());
      return null;
    } on FirebaseException catch (e) {
      // FirebaseException 으로 명시적인 예외 처리
      return e.code;
    } catch (e) {
      // 그 외 다른 종류의 예외도 잡을 수 있도록 일반 catch 블록 추가
      return e.toString();
    }
  }


  Stream<Map<String, dynamic>> fetchUser(String userId) {
    return _firebase.collection('users').doc(userId).snapshots().map((snapshot) {
      if (snapshot.exists) {
        return snapshot.data()!;
      } else {
        throw Exception("User data not found");
      }
    });
  }

  Future<String?> getUser(String userEmail) async {
    try {
      QuerySnapshot querySnapshot = await _firebase
          .collection('users')
          .where('email', isEqualTo: userEmail)
          .get();

      print("값: ${querySnapshot.docs}");
      if (querySnapshot.docs.isEmpty) {
        return '이 이메일로 등록된 사용자가 없습니다';
      } else {
        return null;
      }
    } catch (e) {
      return '사용자 정보를 가져오는 중 오류 발생';
    }
  }

  Future<NLatLng> getUserLatLng() async {
    try {
      String? uid = await Auth().getUiD();

      // Firestore 인스턴스에서 'users' 컬렉션의 특정 유저 문서를 참조하여 데이터를 가져옴
      DocumentSnapshot<Map<String, dynamic>> snapshot = await _firebase
          .collection('users')
          .doc(uid)
          .get();

      // 문서가 존재하는지 확인
      if (snapshot.exists) {
        List<dynamic> location = snapshot.data()?['NLatLng'];
        print("firebase내 유저 좌표: ${location[0]} ${location[1]}");
        // 문서의 데이터에서 'latitude'와 'longitude' 값을 가져옴
        double latitude = location[1];
        double longitude = location[0];

        // NLatLng 객체로 반환
        return NLatLng(latitude, longitude);
      } else {
        throw Exception('User data not found');
      }
    } catch (e) {
      print('Error fetching user coordinates: $e');
      throw Exception('Failed to fetch user coordinates');
    }
  }

  // 미 구현
  //

  Future<String?> updateUser(Map<String, dynamic> user) async {
    String? uid = await Auth().getUiD();

    await _firebase
        .collection('users')
        .doc(uid)
        .update(user)
        .then((value) => print("User Updated"))
        .catchError((error) => print("Failed to update user: $error"));

  }

  Future<void> updateLoginDate() async {
    String? uid = await Auth().getUiD();

    await _firebase
        .collection('users')
        .doc(uid)
        .update({"lastLogin": DateTime.now()
    })
        .then((value) => print("User Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }

  Future<void> updateWeight(double weight) async {
    String? uid = await Auth().getUiD();
    await _firebase
        .collection('users')
        .doc(uid)
        .update({"weight": weight
    })
        .then((value) => print("User Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }

  Future<void> updateHeight(double height) async {
    try {
      String? uid = await Auth().getUiD();
      if (uid == null) {
        print("Failed to get user ID: User not authenticated");
        return;
      }

      await _firebase
          .collection('users')
          .doc(uid)
          .update({"height": height});
      print("User Updated");
    } catch (e) {
      if (e is FirebaseException && e.code == 'unavailable') {
        // 네트워크 연결 문제
        print("Failed to update user: Network connection error");
      } else {
        // 기타 오류
        print("Failed to update user: $e");
      }
    }
  }

  Future<void> updateGender(String gender) async {
    try {
      String? uid = await Auth().getUiD();
      if (uid == null) {
        print("Failed to get user ID: User not authenticated");
        return;
      }

      await _firebase
          .collection('users')
          .doc(uid)
          .update({"gender": gender});
      print("User Updated");
    } catch (e) {
      if (e is FirebaseException && e.code == 'unavailable') {
        // 네트워크 연결 문제
        print("Failed to update user: Network connection error");
      } else {
        // 기타 오류
        print("Failed to update user: $e");
      }
    }
  }

  Future<void> updateTargetCalorie(double targetCalorie) async {
    try {
      String? uid = await Auth().getUiD();
      if (uid == null) {
        print("Failed to get user ID: User not authenticated");
        return;
      }

      await _firebase
          .collection('users')
          .doc(uid)
          .set({"targetCalorie": targetCalorie}, SetOptions(merge: true));
      print("User Updated");
    } catch (e) {
      if (e is FirebaseException && e.code == 'unavailable') {
        // 네트워크 연결 문제
        print("Failed to update user: Network connection error");
      } else {
        // 기타 오류
        print("Failed to update user: $e");
      }
    }
  }


}
