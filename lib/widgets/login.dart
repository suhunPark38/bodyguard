
import 'dart:developer';
import 'package:bodyguard/widgets/forget_password.dart';
import 'package:bodyguard/widgets/sign_up.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';



import '../main.dart';
import '../services/auth_service.dart';
import '../utils/regExp.dart';

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
  FocusNode _emailFocus = new FocusNode();
  FocusNode _passwordFocus = new FocusNode();
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
        physics: BouncingScrollPhysics(), // 스크롤 기능 비활성화
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: topPadding), // 동적 상단 패딩
              Image.asset(
                "assets/loginimage.png",
                width: MediaQuery.of(context).size.width * 0.5,
                height: MediaQuery.of(context).size.width * 0.5,
              ),
              SizedBox(height: betweenPadding), // 동적 간격
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    _showEmailInput(),
                    _showPasswordInput(),
                  ],
                ),
              ),
              ForgetPassword().showForgetButton(context),
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

                        if (result == null) {
                          // 로그인 성공
                          const MyApp();
                        } else {
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

  Widget loginColumn({
    required TextEditingController controller,
    required String labelText,
    bool obscureText = true,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      children: [
        Text(
          labelText,
          maxLines: 1,
          style: TextStyle(fontSize: 25, color: Colors.deepPurpleAccent),
        ),
        SizedBox(
          width: 250.0, // 너비를 200으로 설정
          child: TextField(
            controller: controller,
            maxLines: 1,
            obscureText: false,
            keyboardType: TextInputType.emailAddress,
            enabled: true,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.0), // 모서리 둥글게
                borderSide: BorderSide(color: Colors.blueGrey),
              ),
              floatingLabelAlignment: FloatingLabelAlignment.center,
              fillColor: Colors.lightBlue[50], // 배경색 설정
              filled: true, // fillColor 사용을 활성화
            ),
          ),
        ),
      ],
    );
  }

  Widget _showEmailInput() {
    return Padding(
        padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
        child: Column(
          children: [
            Padding(
                padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: TextFormField(
                  controller: id,
                  keyboardType: TextInputType.emailAddress,
                  focusNode: _emailFocus,
                  decoration: _textFormDecoration('이메일', '이메일을 입력해주세요'),
                  validator: (value) =>
                      CheckValidate().validate(focusNode: _emailFocus, value: value!, emptytext: "이메일", regExp: REGEXP.email, lasttext: "이메일"),
                )),
          ],
        ));
  }

  Widget _showPasswordInput() {
    return Padding(
        padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
        child: Column(
          children: [
            Padding(
                padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: TextFormField(
                  controller: pw,
                  focusNode: _passwordFocus,
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: true,
                  decoration: _textFormDecoration( "비밀번호", "$pwtext"
                  ),
                  validator: (value) =>
                      CheckValidate().validatePassword(_passwordFocus, value!, pwtext),
                )),
          ],
        ));
  }

  InputDecoration _textFormDecoration(hintText, helperText) {
    return new InputDecoration(
      contentPadding: EdgeInsets.fromLTRB(0, 16, 0, 0),
      hintText: hintText,
      helperText: helperText,
    );
  }
}
