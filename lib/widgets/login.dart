import 'dart:developer';
import 'package:bodyguard/widgets/forget_password.dart';
import 'package:bodyguard/widgets/sign_up.dart';
import 'package:flutter/material.dart';

import '../services/auth_service.dart';
import '../utils/regExp.dart';
import 'customForm.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool isLoading = false;
  TextEditingController id = TextEditingController();
  TextEditingController pw = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  FocusNode _emailFocus = FocusNode();
  FocusNode _passwordFocus = FocusNode();
  //final pwtext = "특수문자, 대소문자, 숫자 포함 8자 이상 15자 이내로 입력하세요.";
  String pwtext = "6자 이상으로 입력하세요";

  @override
  Widget build(BuildContext context) {
    double topPadding =
        MediaQuery.of(context).size.height * 0.1; // 화면 높이의 10%를 상단 패딩으로 설정
    double betweenPadding =
        MediaQuery.of(context).size.height * 0.02; // 화면 높이의 2%를 위젯 간 간격으로 설정

    return Scaffold(
      body: SingleChildScrollView(
        // 스크롤뷰로 전체 내용을 감싼다.
        physics: const BouncingScrollPhysics(), // 스크롤 기능 비활성화
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: topPadding), // 동적 상단 패딩
              Image.asset(
                "assets/body_logo_icon.png",
                width: MediaQuery.of(context).size.width * 0.5,
                height: MediaQuery.of(context).size.width * 0.5,
              ),
              SizedBox(height: betweenPadding), // 동적 간격
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    CustomForm().buildTextField(
                      label: "이메일", // 이메일
                      controller: id,
                      focusNode: _emailFocus,
                      keyboardType: TextInputType.emailAddress,
                      regExp: REGEXP.email,
                    ),
                    CustomForm().buildTextField(
                      label: "비밀번호", // 비밀번호
                      controller: pw,
                      focusNode: _passwordFocus,
                      obscureText: true,
                      keyboardType: TextInputType.visiblePassword,
                      regExp: REGEXP.password,
                      errorText: "6자 이상 입력하세요"
                    ),
                  ],
                ),
              ),
              TextButton(
                onPressed: () => showForgetPasswordDialog(context),
                child: Text("비밀번호 재설정"),
              ),
              Builder(
                builder: (context) {
                  return Container(
                    margin: EdgeInsets.symmetric(horizontal: 30.0),
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState?.validate() != true) {
                          // 유효성 검사가 true가 아니면
                          return; // 더 이상 진행하지 않음
                        }
                        setState(() {
                          isLoading = true;
                        });
                        log("받은 id 비번: ${id.text} ${pw.text}");
                        String? result = await Auth().userLogin(email: id.text.trim(), pw: pw.text.trim());

                        setState(() {
                          isLoading = false; // 로딩 종료
                        });

                        if (result != null) {
                          // 로그인 실패, 결과 변수에서 오류 메시지를 사용합니다.
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text("로그인에 실패했습니다: $result"),  // 로그인 실패 메시지 출력
                            duration: Duration(seconds: 2),
                          ));
                        }
                      },
                      child: isLoading
                          ? CircularProgressIndicator(
                        valueColor:
                        AlwaysStoppedAnimation<Color>(Colors.white),
                      )
                          : Text("로그인"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.lightBlue[50],
                        minimumSize: Size(250, 50),
                      ),
                    ),
                  );
                },
              ),
              TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SignUp(), // SignUp을 여러분의 회원가입 페이지 위젯으로 대체하세요
                      ),
                    );
                  },
                  child: Text("회원가입")),
            ],
          ),
        ),
      ),
    );
  }

}
