import 'dart:developer';
import 'package:bodyguard/widgets/forget_password.dart';
import 'package:bodyguard/screens/sign_up_page/sign_up.dart';
import 'package:flutter/material.dart';

import '../../services/auth_service.dart';
import '../../utils/regExp.dart';
import '../../widgets/custom_form.dart';

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
  String pwtext = "6자 이상으로 입력하세요";

  @override
  Widget build(BuildContext context) {
    double topPadding = MediaQuery.of(context).size.height * 0.1;
    double betweenPadding = MediaQuery.of(context).size.height * 0.02;

    return Scaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: topPadding),
              Image.asset(
                "assets/body_logo_icon.png",
                width: MediaQuery.of(context).size.width * 0.5,
                height: MediaQuery.of(context).size.width * 0.5,
              ),
              SizedBox(height: betweenPadding),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    CustomForm().buildTextField(
                      label: "이메일",
                      controller: id,
                      focusNode: _emailFocus,
                      keyboardType: TextInputType.emailAddress,
                      regExp: REGEXP.email,
                    ),
                    CustomForm().buildTextField(
                      label: "비밀번호",
                      controller: pw,
                      focusNode: _passwordFocus,
                      obscureText: true,
                      keyboardType: TextInputType.visiblePassword,
                      regExp: REGEXP.password,
                      errorText: pwtext,
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
                    child: FilledButton(
                      onPressed: () async {
                        if (_formKey.currentState?.validate() != true) {
                          return;
                        }
                        setState(() {
                          isLoading = true;
                        });
                        log("받은 id 비번: ${id.text} ${pw.text}");
                        String? result = await Auth().userLogin(
                            email: id.text.trim(), pw: pw.text.trim());

                        setState(() {
                          isLoading = false;
                        });

                        if (result != null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("로그인에 실패했습니다: $result"),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        }
                      },
                      child: isLoading
                          ? CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            )
                          : Text("로그인"),
                      style: FilledButton.styleFrom(
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
                      builder: (context) => SignUp(),
                    ),
                  );
                },
                child: Text("회원가입"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
