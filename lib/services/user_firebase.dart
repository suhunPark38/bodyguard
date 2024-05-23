import 'package:bodyguard/model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';

import 'auth_service.dart';

class UserFirebase {
  FirebaseFirestore _firebase = FirebaseFirestore.instance;
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

  Stream<UserInfoModel> getUserInfo({required String uid}) {
    print("getUserInfo: $uid");
    return _firebase
        .collection('users')
        .doc(uid)
        .snapshots()
        .map((snapshot) {
      print("getUserInfo: $uid");
      print("Firestore snapshot data: ${snapshot.data()}");
      // `snapshot.data()`를 통해 데이터를 가져옵니다. `data()`는 `Map<String, dynamic>` 타입을 반환합니다.
      return UserInfoModel.fromJson(snapshot.data() as Map<String, dynamic>);
    });
  }

  Future<UserInfoModel?> getUserInfoF() async {
    String? uid = await Auth().getUiD();

    if (uid == null) {
      return null;
    }

    // Firestore에서 사용자 정보를 가져옵니다.
    DocumentSnapshot snapshot = await _firebase.collection('users').doc(uid).get();

    if (snapshot.exists) {
      print("getUserInfo: $uid");
      print("Firestore snapshot data: ${snapshot.data()}");

      // `snapshot.data()`를 통해 데이터를 가져옵니다. `data()`는 `Map<String, dynamic>` 타입을 반환합니다.
      return UserInfoModel.fromJson(snapshot.data() as Map<String, dynamic>);
    } else {
      print("No user data found for uid: $uid");
      return null;
    }
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

  Future<String?> updateUser({required UserInfoModel user}) async {
    String? uid = await Auth().getUiD();

    await _firebase
          .collection('users')
          .doc(uid)
          .update(user.toJson())
          .then((value) => print("User Updated"))
          .catchError((error) => print("Failed to update user: $error"));

  }

  void updateAddress(String address) {
    String? uid = Auth().getUiD() as String?;

    if (uid == null) {
      return;
    }
    _firebase
        .collection('users')
        .doc(uid)
        .update({'address': address})
        .then((value) => print("User Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }

  Future<NLatLng> getUserLatLng() async {
    try {
      String? uid = await Auth().getUiD();

      // Firestore 인스턴스에서 'users' 컬렉션의 특정 유저 문서를 참조하여 데이터를 가져옴
      DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance
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

}
