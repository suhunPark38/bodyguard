
import 'package:flutter/cupertino.dart';
enum REGEXP{
  email, password, number, age, text;
}

class CheckValidate {

  //이메일 관련 정규식

  //비밀번호 관련 정규식
  String? validatePassword(FocusNode focusNode, String value, String text) {
    if (value.isEmpty) {
      focusNode.requestFocus();
      return '비밀번호를 입력하세요.';
    } else {
      //'특수문자, 대소문자, 숫자 포함 6 ~ 15자 이내으로 입력하세요.'
      //Pattern pattern = r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[$@$!%*#?&])[A-Za-z\d$@$!%*#?&]{8, 15}$';

      //단순 6자 이상
      Pattern pattern = r'^.{6,}$';
      RegExp regExp = RegExp(pattern as String);
      if (!regExp.hasMatch(value)) {
        focusNode.requestFocus();
        return text;
      } else {
        return null;
      }
    }
  }

  String? validatenumber(
      {required FocusNode focusNode,
      required String value,
      required String emptytext,
      required String expError,
      required REGEXP regExp}) {
    if (value.isEmpty) {
      focusNode.requestFocus();
      return emptytext;
    } else {
      //'특수문자, 대소문자, 숫자 포함 6 ~ 15자 이내으로 입력하세요.'
      //Pattern pattern = r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[$@$!%*#?&])[A-Za-z\d$@$!%*#?&]{8, 15}$';
      //단순 6자 이상
      Pattern pattern = r'^\d+(\.\d+)?$';
      RegExp regExp = RegExp(pattern as String);
      if (!regExp.hasMatch(value)) {
        focusNode.requestFocus();
        return expError;
      } else {
        return null;
      }
    }
  }

  String? validate(
      {required FocusNode focusNode,
        required String value,
        required String emptytext,
        required REGEXP regExp,
      String? lasttext = null}) {
    if (value.isEmpty) {
      focusNode.requestFocus();
      return "${emptytext}을(를) 입력하세요";
    } else {
      RegExp regexp = getPattern(regExp);
      if (!regexp.hasMatch(value)) {
        focusNode.requestFocus();
        return "${lasttext}" ?? "형식에 맞지 않습니다. 형식에 맞게 작성해주세요";
      } else {
        return null;
      }
    }
  }
  String? validate1({
    required String value,
    required String emptytext,
    required REGEXP regExp,
    String? lasttext = null}) {
    if (value.isEmpty) {
      return "$emptytext을(를) 입력하세요";
    } else {
      RegExp regexp = getPattern(regExp);
      if (!regexp.hasMatch(value)) {
        return "${lasttext ?? "형식"}에 맞게 작성해주세요";
      } else {
        return null;
      }
    }
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
        return RegExp(r'^\S+$' as String);
    }
  }




}
