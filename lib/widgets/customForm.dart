import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import '../utils/regExp.dart';


class CustomForm{


  void LoginForm(){

  }

  // 기본 데코레이션을 위한 함수
    InputDecoration buildDefaultDecoration(String labelText){
      return InputDecoration(
        labelText: labelText,
        fillColor: Colors.white, // 채우기 색
        filled: true, // 채우기 유무 default = false
        labelStyle: TextStyle(color: Colors.black), // 레이블 스타일
        focusedBorder: OutlineInputBorder(), // 포커스 시 테두리
        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)), // 활성화 시 테두리
        errorStyle: TextStyle(color: Colors.redAccent), // 오류 텍스트 스타일
        errorBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.red)), // 오류 시 테두리
        focusedErrorBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.red, width: 2)), // 포커스된 상태의 오류 테두리
        border: InputBorder.none, // 기본 테두리 설정 없앰
      );
    }



  // 닉네임 텍스트 필드
  Container nickNameTextField({
      required TextEditingController controller,
      required FocusNode focusNode,
      InputDecoration? decoration,
      EdgeInsets padding = const EdgeInsets.fromLTRB(20, 10, 20, 0),
    }) {
      return Container(
        padding: padding,
        child: TextFormField(
          controller: controller,
          keyboardType: TextInputType.name,
          focusNode: focusNode,
          decoration: decoration ?? buildDefaultDecoration('닉네임'),
          validator: (value) =>
              CheckValidate().validate(focusNode: focusNode, value: value!, emptytext: "닉네임", regExp: REGEXP.text),
        ),
      );
    }

  // 이메일 텍스트 필드
  Container emailTextField({
      required TextEditingController controller,
      required FocusNode focusNode,
      InputDecoration? decoration,
      EdgeInsets padding = const EdgeInsets.fromLTRB(20, 10, 20, 0),
    }) {
    return Container(
      padding: padding,
      child: Column( // Align 위젯을 사용하여 TextFormField를 중앙에 배치
        mainAxisAlignment:  MainAxisAlignment.center,
        children: [
          TextFormField(
            controller: controller,
            keyboardType: TextInputType.emailAddress,
            focusNode: focusNode,
            decoration: decoration ?? buildDefaultDecoration("이메일"),
            validator: (value) =>
                CheckValidate().validate(focusNode: focusNode,value: value!, emptytext: "이메일", regExp: REGEXP.email, lasttext: "이메일"),
                //CheckValidate().validate1(value: value!, emptytext: "이메일", regExp: REGEXP.email, lasttext: "이메일"),
          ),
        ]
      ),
    );
    }

  // 비밀번호 텍스트 필드
  Container passwordTextField({
      required TextEditingController controller,
      required FocusNode focusNode,
      InputDecoration? decoration,
      EdgeInsets padding = const EdgeInsets.fromLTRB(20, 10, 20, 0),
    }) {
      return Container(
        padding: padding,
        child: TextFormField(
          controller: controller,
          obscureText: true,
          focusNode: focusNode,
          decoration: decoration ?? buildDefaultDecoration('비밀번호'),
          validator: (value) => CheckValidate().validate(focusNode: focusNode, value: value!, emptytext: "비밀번호", regExp: REGEXP.password, lasttext: "6자 이상"),
        ),
      );
    }

  // 나이 텍스트 필드
  Container ageTextField({
      required TextEditingController controller,
      required FocusNode focusNode,
      InputDecoration? decoration,
      EdgeInsets padding = const EdgeInsets.fromLTRB(20, 10, 20, 0),
    }) {
      return Container(
        padding: padding,
        child: TextFormField(
          controller: controller,
          keyboardType: TextInputType.number,
          focusNode: focusNode,
          decoration: decoration ?? buildDefaultDecoration('나이'),
          validator: (value) => CheckValidate().validate(focusNode: focusNode, value: value!, emptytext: "나이", regExp: REGEXP.age, lasttext: "나이"),
        ),
      );
    }

  // 생년월일 텍스트 필드
  Container sexTextField({
      required TextEditingController controller,
      required FocusNode focusNode,
      InputDecoration? decoration,
      EdgeInsets padding = const EdgeInsets.fromLTRB(20, 10, 20, 0),
    }) {
      return Container(
        padding: padding,
        child: TextFormField(
          controller: controller,
          keyboardType: TextInputType.name,
          focusNode: focusNode,
          decoration: decoration ?? buildDefaultDecoration('생년월일'),
          validator: (value) => CheckValidate().validate(focusNode: focusNode, value: value!, emptytext: "생년월일", regExp: REGEXP.text, lasttext: "생년월일 8자리"),
        ),
      );
    }

  // 키 텍스트 필드
  Container heightTextField({
      required TextEditingController controller,
      required FocusNode focusNode,
      InputDecoration? decoration,
      EdgeInsets padding = const EdgeInsets.fromLTRB(20, 10, 20, 0),
    }) {
      return Container(
        padding: padding,
        child: TextFormField(
          controller: controller,
          keyboardType: TextInputType.number,
          focusNode: focusNode,
          decoration: decoration ?? buildDefaultDecoration('키(cm)'),
          validator: (value) => CheckValidate().validate(focusNode: focusNode, value: value!, emptytext: "키(cm)", regExp: REGEXP.number),
        ),
      );
    }

  // 몸무게 텍스트 필드
  Container weightTextField({
      required TextEditingController controller,
      required FocusNode focusNode,
      InputDecoration? decoration,
      EdgeInsets padding = const EdgeInsets.fromLTRB(20, 10, 20, 0),
    }) {
      return Container(
        padding: padding,
        child: TextFormField(
          controller: controller,
          keyboardType: TextInputType.number,
          focusNode: focusNode,
          decoration: decoration ?? buildDefaultDecoration('몸무게(kg)'),
          validator: (value) => CheckValidate().validate(focusNode: focusNode, value: value!, emptytext: "몸무게(kg)", regExp: REGEXP.number),
        ),
      );
    }




  Container genderSelectField({
    required TextEditingController controller,
    required BuildContext context,
    EdgeInsets padding = const EdgeInsets.fromLTRB(20, 10, 20, 0),
  }) {
    return Container(
      padding: padding,
      child: StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          String gender = controller.text.isEmpty ? '남' : controller.text; // Default gender is male if none is set
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text("성별", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Row(
                children: <Widget>[
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          gender = '남';
                          controller.text = gender;
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: gender == '남' ? Colors.blueGrey[200] : Colors.grey[300],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text('남', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          gender = '여';
                          controller.text = gender;
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: gender == '여' ? Colors.blueGrey[200] : Colors.grey[300],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text('여', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }


}