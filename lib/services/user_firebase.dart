import 'package:bodyguard/model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserFirebase{

  Future<String?> createUserInfo({required uid,required UserInfoModel user}) async {
    try{
      await FirebaseFirestore.instance.collection('users').doc(uid).set(user.toJson());
      return null;
    } on FirebaseException catch (e) {  // FirebaseException 으로 명시적인 예외 처리
      return e.code;
    } catch (e) {  // 그 외 다른 종류의 예외도 잡을 수 있도록 일반 catch 블록 추가
      return e.toString();
    }
  }

  Stream<UserInfoModel> getUserInfo({required String uid}) {
    print("getUserInfo: $uid");
      return FirebaseFirestore.instance.collection('users').doc(uid).snapshots().map((snapshot) {

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

      if (querySnapshot.docs.isEmpty) {
        return 'No user found with this email';
      } else {
        for (var doc in querySnapshot.docs) {
          print(doc.data()); // 출력 또는 다른 처리
          return null;
        }
      }
    } catch (e) {
      return 'Error fetching user';
    }
  }


}