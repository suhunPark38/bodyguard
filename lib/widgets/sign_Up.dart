import 'package:bodyguard/model/user_model.dart';
import 'package:bodyguard/providers/health_data_provider.dart';
import 'package:bodyguard/services/user_firebase.dart';
import 'package:bodyguard/widgets/custom_form.dart';
import 'package:bodyguard/widgets/search_address.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/auth_service.dart';
import '../utils/regExp.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final GlobalKey<FormState> _formKey =
      GlobalKey<FormState>(); // Form의 key를 생성합니다.

  bool isLoading = false;
  List<String> data = [
    "닉네임",
    "이메일",
    "비밀번호",
    "나이",
    "성별",
    "키(cm)",
    "몸무게(kg)",
    "주소",
    "세부주소"
  ];
  late List<TextEditingController> controllers;
  late List<FocusNode> focusNodes;
  Map<String, dynamic>? selectedadress;

  @override
  initState() {
    super.initState();
    controllers =
        List.generate(data.length, (index) => TextEditingController());
    focusNodes = List.generate(data.length, (index) => FocusNode());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("회원가입"),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          //onPressed: () => Navigator.pop(context),
          onPressed: () async {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: userInfo(),
        ),
      ),
    );
  }

  Form userInfo() {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 50),
          CustomForm().buildTextField(
            label: data[0], // 닉네임
            controller: controllers[0],
            focusNode: focusNodes[0],
            regExp: REGEXP.text,
          ),
          CustomForm().buildTextField(
            label: data[1],
            // 이메일
            controller: controllers[1],
            focusNode: focusNodes[1],
            keyboardType: TextInputType.emailAddress,
            regExp: REGEXP.email,
          ),
          CustomForm().buildTextField(
            label: data[2],
            // 비밀번호
            controller: controllers[2],
            focusNode: focusNodes[2],
            obscureText: true,
            keyboardType: TextInputType.visiblePassword,
            regExp: REGEXP.password,
            errorText: "6자 이상 입력하세요",
          ),
          CustomForm().buildTextField(
              label: data[3],
              // 나이
              controller: controllers[3],
              focusNode: focusNodes[3],
              keyboardType: TextInputType.number,
              regExp: REGEXP.age,
              errorText: "200 미만 숫자만 가능합니다."),
          CustomForm().genderSelectField(
            controller: controllers[4],
            context: context,
          ),
          CustomForm().buildTextField(
            label: data[5],
            // 키
            controller: controllers[5],
            focusNode: focusNodes[5],
            keyboardType: TextInputType.number,
            regExp: REGEXP.number,
          ),
          CustomForm().buildTextField(
            label: data[6],
            controller: controllers[6],
            focusNode: focusNodes[6],
            regExp: REGEXP.number,
            keyboardType: TextInputType.number,
          ),
          Container(
            padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
            child: TextFormField(
              controller: controllers[7],
              focusNode: focusNodes[7],
              readOnly: true,
              decoration: CustomForm()
                  .buildDefaultDecoration(labelText: data[7], isReadOnly: true),
              onTap: () async {
                selectedadress = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SearchAddress()),
                );
                if (selectedadress != null) {
                  setState(() {
                    controllers[7].text = selectedadress!['roadAddress'];
                  });
                }
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '주소창을 먼저 눌러주세요';
                }
                return null;
              },
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
            child: TextFormField(
              controller: controllers[8],
              focusNode: focusNodes[8],
              decoration:
                  CustomForm().buildDefaultDecoration(labelText: data[8]),
              readOnly: controllers[7].text.isEmpty,
              // 첫 번째 필드가 비어있으면 readOnly 상태로 설정
              validator: (value) {
                return null;
              },
            ),
          ),
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
                  pw: controllers[2].text.trim(),
                );
                if (result is String) {
                  // 문자열 반환 시, 에러 메시지로 간주하고 스낵바를 표시
                  controllers[1].text = "";
                  _formKey.currentState!.validate();
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text(result)));
                } else {
                  print("시작");
                  if (selectedadress != null) {
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
                              "roadAddress": controllers[7].text.trim(),
                              "detailAddress": controllers[8].text.trim(),
                              "NLatLng": [
                                selectedadress!['x'],
                                selectedadress!['y']
                              ],

                            })) !=
                        null) {
                      print("성공?");
                    }
                  } else {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text('주소를 선택해주세요')));
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
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  )
                : Text("회원가입"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.lightBlue[50],
              minimumSize: Size(250, 50),
            ),
          ),
          SizedBox(height: 30),
        ],
      ),
    );
  }
}
