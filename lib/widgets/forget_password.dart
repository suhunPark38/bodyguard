import 'dart:ui';

import 'package:bodyguard/utils/regExp.dart';
import 'package:flutter/material.dart';

import '../services/auth_service.dart';

class ForgetPassword {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController email = TextEditingController();
  final FocusNode emailFocusNode = FocusNode();

  TextButton showForgetButton(BuildContext context) {
    return TextButton(
      onPressed: () {
        showSleekDialog(context);
      },
      child: Text("비밀번호 찾기"),
    );
  }

  Future showSleekDialog(BuildContext context) {
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24.0),
          ),
          elevation: 5,
          title: Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Text(
              "비밀번호 재설정",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22,
                color: Colors.deepPurple,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          content: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    child: Text(
                      "등록된 이메일을 입력하시면,\n비밀번호 재설정 링크를 보내드립니다.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[800],
                      ),
                    ),
                  ),
                  TextFormField(
                    controller: email,
                    focusNode: emailFocusNode,
                    style: TextStyle(fontSize: 14),
                    decoration: InputDecoration(
                      labelText: "이메일 주소",
                      labelStyle: TextStyle(color: Colors.deepPurple),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: BorderSide.none,
                      ),
                      fillColor: Color(0x673AB7FF),
                      filled: true,
                    ),
                    validator: (value) =>
                      CheckValidate().validate(focusNode: emailFocusNode, value: value!, emptytext: "이메일", lasttext: "이메일 형식",regExp: REGEXP.email)

                  ),
                ],
              ),
            ),
          ),
          //actionsPadding: EdgeInsets.fromLTRB(16.0, 0, 16.0, 20.0),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  // 유효성 검사를 통과하면 이메일 처리 로직을 실행
                  Auth().sendPWResetEmail(email: email.text).then((result) {
                    if (result == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('비밀번호 재설정 링크를 발송했습니다.', style: TextStyle(color: Colors.white)),
                          backgroundColor: Colors.deepPurple,
                        ),
                      );
                      Navigator.of(context).pop();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(result)),
                      );
                    }
                  });
                }
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.deepPurple,
                //padding: EdgeInsets.symmetric(horizontal: 35, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              ),
              child: Text("확인", style: TextStyle(fontSize: 16)),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.grey,
                //padding: EdgeInsets.symmetric(horizontal: 35, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              ),
              child: Text("취소", style: TextStyle(fontSize: 16)),
            ),
          ],

        );
      },
    );
  }






}




/*
actions: <Widget>[
  ElevatedButton(
    onPressed: () async {
      if (_formKey.currentState!.validate()) {
        // 유효성 검사를 통과하면 이메일 처리 로직을 실행
        Auth().sendPWResetEmail(email: email.text).then((result) {
          if (result == null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('비밀번호 재설정 링크를 발송했습니다.', style: TextStyle(color: Colors.white)),
                backgroundColor: Colors.deepPurple,
              ),
            );
            Navigator.of(context).pop();
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(result)),
            );
          }
        });
      }
    },
    style: ElevatedButton.styleFrom(
      primary: Colors.deepPurple, // 버튼 배경색
      onPrimary: Colors.white, // 버튼 텍스트 색상
      padding: EdgeInsets.symmetric(horizontal: 35, vertical: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),
    child: Text("확인", style: TextStyle(fontSize: 16)),
  ),
  ElevatedButton(
    onPressed: () => Navigator.of(context).pop(),
    style: ElevatedButton.styleFrom(
      primary: Colors.grey,
      onPrimary: Colors.black,
      padding: EdgeInsets.symmetric(horizontal: 35, vertical: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),
    child: Text("취소", style: TextStyle(fontSize: 16)),
  ),
],
*/