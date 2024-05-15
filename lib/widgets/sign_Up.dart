import 'package:bodyguard/model/user_model.dart';
import 'package:bodyguard/services/user_firebase.dart';
import 'package:bodyguard/widgets/customForm.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../services/auth_service.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>(); // Form의 key를 생성합니다.\
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool isLoading = false;
  List<String> data = [
    "닉네임",
    "이메일",
    "비밀번호",
    "나이",
    "성별",
    "키",
    "몸무게",
  ];
  late List<TextEditingController> controllers;
  late List<FocusNode> focusNodes;

  @override
  initState(){
    super.initState();
    controllers = List.generate(data.length, (index) => TextEditingController());
    focusNodes = List.generate(data.length, (index) => FocusNode());
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("회원가입"),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: userInfo()
    );
  }

  SingleChildScrollView userInfo(){
    bool usedID = false;
    return SingleChildScrollView(
          child: Center(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 50),
                  CustomForm().nickNameTextField(
                      controller: controllers[0],
                      focusNode: focusNodes[0]),

                  CustomForm().emailTextField(
                      controller: controllers[1],
                      focusNode: focusNodes[1]
                      ),

                  CustomForm().passwordTextField(
                      controller: controllers[2],
                      focusNode: focusNodes[2]),

                  CustomForm().ageTextField(
                      controller: controllers[3],
                      focusNode: focusNodes[3]),

                  CustomForm().genderSelectField(
                    controller: controllers[4],
                    context: context,),

                  CustomForm().heightTextField(
                      controller: controllers[5],
                      focusNode: focusNodes[5]),

                  CustomForm().weightTextField(
                      controller: controllers[6],
                      focusNode: focusNodes[6]),

                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      setState(() {
                        isLoading = true;
                      });
                      print(controllers[3].text);
                      if (_formKey.currentState!.validate()) {
                        var result = await Auth().createUser(
                            email: controllers[1].text.trim(),
                            pw: controllers[2].text.trim()
                        );
                        if (result is String) {
                          // 문자열 반환 시, 에러 메시지로 간주하고 스낵바를 표시
                        controllers[1].text = "";
                        setState(() {
                          usedID = true;
                        });
                        _formKey.currentState!.validate();
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result)));
                        } else {

                          // UserCredential 객체가 반환됐다면 데이터베이스에 사용자 정보 저장
                          if (UserFirebase().createUserInfo(
                              uid: Auth().getUid(result),
                              user: UserInfoModel.fromJson({
                                "nickName": controllers[0].text.trim(),
                                "email": controllers[1].text.trim(),
                                "age": controllers[3].text.trim(),
                                "gender": controllers[4].text.trim(),
                                "height": controllers[5].text.trim(),
                                "weight": controllers[6].text.trim(),
                              })
                          ) != null){
                            print("성공?");
                          }
                          setState(() {
                            isLoading = false; // 로딩 종료
                          });
                          Navigator.pop(context);
                        }
                      }
                      setState(() {
                        isLoading = false; // 로딩 종료
                      });
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
                  SizedBox(height: 30),
                ],
              ),
            ),
          ),
        );
  }





}

/*
...data.asMap().entries.map((entry) {
                int index = entry.key;
                String field = entry.value;
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                  child: Container(
                    margin: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width * 0.11, 0, MediaQuery.of(context).size.width * 0.11, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(field),
                        SizedBox(width: 10),
                        Expanded(
                          child: TextFormField(
                            controller: controllers[index],
                            decoration: InputDecoration(hintText: field),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return '$field를 입력해주세요';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
* */