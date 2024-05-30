import 'dart:developer';

import 'package:bodyguard/services/user_firebase.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Auth{

  String errorMessage = "";
  Future<void> getInstance() async {
    await FirebaseAuth.instance;
  }

  void userLoginOut() {
    FirebaseAuth.instance.signOut();
  }

  Future<String?> userLogin({required String email, required String pw}) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: pw);
      return null; // 성공했을 때 null 반환
    } on FirebaseAuthException catch (e) {
      log(e.code as String);
      switch (e.code) {
        case "network-request-failed":
          errorMessage = "통신 에러가 발생했습니다. 인터넷 연결을 확인해주세요.";
          break;
        case "user-disabled":
          errorMessage = "사용자 계정이 비활성화되었습니다.";
          break;
        case "user-not-found":
        case "wrong-password":
          errorMessage = "이메일 또는 비밀번호가 정확하지 않습니다. 정보를 확인하고 다시 시도해주세요.";
          break;
        case "too-many-requests":
          errorMessage = "요청이 너무 많습니다. 나중에 다시 시도해주세요.";
          break;
        case "invalid-credential":
          errorMessage = "이메일이나 비밀번호가 다름니다. 확인해주세요";
          break;
      }
      return errorMessage; // 에러 메시지 반환
    } catch (e) {
      return "알 수 없는 에러가 발생했습니다: $e"; // 다른 예외가 발생한 경우
    }
  }


  Future<Object> createUser({required String email, required String pw}) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: pw);
      return userCredential; // 성공했을 때 null 반환
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "network-request-failed":
          errorMessage = "통신 에러가 발생했습니다. 인터넷 연결을 확인해주세요.";
          break;
        case "email-already-in-use":
          errorMessage = "이미 사용 중인 이메일입니다. 다른 이메일을 사용해주세요.";
          break;
        case "too-many-requests":
          errorMessage = "요청이 너무 많습니다. 나중에 다시 시도해주세요.";
          break;
      }
      return errorMessage; // 에러 메시지 반환
    } catch (e) {
      return "알 수 없는 에러가 발생했습니다: $e"; // 다른 예외가 발생한 경우
    }
  }

  Future<String?> sendPWResetEmail({required String email}) async {
    try {
      String? userCheck = await UserFirebase().getUser(email);
      if (userCheck != null) {
        return "이메일을 확인해주세요";
      }
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      return null;
    } on FirebaseAuthException catch (e) {
      log(e.code);
      switch (e.code) {
        default:
          return e.code;
      }
    }
  }


  String getUid(Object value){
    return (value as UserCredential).user!.uid;
  }

  Future<String?> getUiD() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return user.uid;  // 사용자 UID 반환
    } else {
      return null;  // 로그인한 사용자가 없으면 null 반환
    }
  }

  Future<String?> updatePassword(String newPW) async {
      try {
        await FirebaseAuth.instance.currentUser?.updatePassword(newPW);
        return null;
      } on FirebaseAuthException catch (e) {
          return ('비밀번호 업데이트 실패: ${e.message}');
      } catch (e) {
        return ('비밀번호 업데이트 중 알 수 없는 에러가 발생했습니다: $e');
      }
    }

  String getCurrentUid(){
    print("getCurrentUid: ${FirebaseAuth.instance.currentUser!.uid}");
    return FirebaseAuth.instance.currentUser!.uid;
  }

  String? searchUser(){

  }

}