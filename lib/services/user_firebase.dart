import 'package:bodyguard/model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'auth_service.dart';

class UserFirebase {
  Future<String?> createUserInfo(
      {required uid, required UserInfoModel user}) async {
    try {
      await FirebaseFirestore.instance
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
    return FirebaseFirestore.instance
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

  Future<String?> getUser(String userEmail) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
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

  void updateUser(String pw, UserInfoModel user, String address) {
    String? uid = Auth().getUiD() as String?;

    if (uid == null) {
      return;
    }
    Auth().updatePassword(pw);
    FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .update({
          'nickName': user.nickName,
          'email': user.email,
          'height': user.height,
          'weight': user.weight,
          'age': user.age,
          'address': address
        })
        .then((value) => print("User Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }

  void updateAddress(String address) {
    String? uid = Auth().getUiD() as String?;

    if (uid == null) {
      return;
    }
    FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .update({'address': address})
        .then((value) => print("User Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }
}
