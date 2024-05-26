
import 'package:flutter/cupertino.dart';

import '../services/auth_service.dart';
enum REGEXP{
  email, password, number, age, text;
}

class CheckValidate {

  //이메일 관련 정규식

  //비밀번호 관련 정규식
  String? validate(
      {required FocusNode focusNode,
        required String value,
        required String emptytext,
        required REGEXP regExp,
      String? lasttext}) {
    if (value.isEmpty) {
      focusNode.requestFocus();
      return "${emptytext}을(를) 입력하세요";
    } else {
      RegExp regexp = getPattern(regExp);
      if (!regexp.hasMatch(value)) {
        focusNode.requestFocus();
        return lasttext ?? "형식에 맞게 작성해주세요";
      } else {
        return null;
      }
    }
  }

  //회원정보 수정할 때 쓰이는 정규식체크
  Future<String?> checkPW({required FocusNode focusNode, required String value}) async {
    // 값이 비어 있는 경우, 검증 없이 통과
    if (value.isEmpty) {
      return null;
    }

    // 값이 있을 경우, 정규식을 사용하여 검증
    RegExp regexp = getPattern(REGEXP.password);
    if (!regexp.hasMatch(value)) {
      focusNode.requestFocus();
      return "6자 이상 입력하세요";
    }

    // 여기까지 코드가 도달했다면, 정규식을 통과한 것입니다.
    // 비밀번호 업데이트 로직은 여기에서 처리하지 않고 호출하는 곳에서 처리합니다.
    return null;
  }

  RegExp getPattern(REGEXP regexp){
    switch (regexp){
      case REGEXP.email:
        return RegExp(r'^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$' as String);
      case REGEXP.password:
        return RegExp(r'^.{6,}$' as String);
      case REGEXP.number:
        return RegExp(r'^\d+(\.\d+)?$' as String);
      case REGEXP.age:
        return RegExp(r'^([1-9]|[1-9]\d|1\d\d|200)$' as String);
        // TODO: Handle this case.
      case REGEXP.text:
        return RegExp(r'^.+$' as String);
    }
  }




}
