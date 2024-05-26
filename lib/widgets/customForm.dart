import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import '../utils/regExp.dart';


class CustomForm{

  // 기본 데코레이션을 위한 함수
    InputDecoration buildDefaultDecoration({required String labelText, bool isReadOnly = false}){
      return InputDecoration(
        labelText: labelText,
        fillColor: Colors.white, // 채우기 색
        filled: true, // 채우기 유무 default = false
        labelStyle: TextStyle(color: Colors.black), // 레이블 스타일
        focusedBorder: isReadOnly ?  InputBorder.none : OutlineInputBorder(), // 포커스 시 테두리
        enabledBorder: isReadOnly ?
          OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)) : // readOnly일 때 파란색 테두리
          OutlineInputBorder(borderSide: BorderSide(color: Colors.black)), // readOnly가 아닐 때 회색 테두리
        errorStyle: TextStyle(color: Colors.redAccent), // 오류 텍스트 스타일
        errorBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.red)), // 오류 시 테두리
        focusedErrorBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.red, width: 2)), // 포커스된 상태의 오류 테두리
        border: InputBorder.none, // 기본 테두리 설정 없앰
      );
    }

  Widget buildTextField({
    required String label,
    required TextEditingController controller,
    required FocusNode focusNode,
    REGEXP regExp = REGEXP.text,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
    String? Function(String?)? validator,
    InputDecoration? decoration,
    String? errorText,
    EdgeInsets padding = const EdgeInsets.fromLTRB(20, 10, 20, 0),
    bool readOnly = false

  }) {
    return Container(
      padding: padding,
      child: TextFormField(
        controller: controller,
        focusNode: focusNode,
        obscureText: obscureText,
        readOnly: readOnly,
        keyboardType: keyboardType,
        decoration: decoration ?? buildDefaultDecoration(labelText: label),
        validator: validator ?? (value) => CheckValidate().validate(
          focusNode: focusNode,
          value: value!,
          emptytext: label,
          regExp: regExp,
          lasttext: errorText,
        ),
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
              SizedBox(height: 5),
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