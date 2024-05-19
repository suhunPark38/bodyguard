import 'package:flutter/material.dart';
import 'package:bodyguard/utils/regExp.dart';
import '../services/auth_service.dart';

void showForgetPasswordDialog(BuildContext context) {
  final TextEditingController emailController = TextEditingController();
  final FocusNode emailFocusNode = FocusNode();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        bool isLoading = false;
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
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
                content: Container(
                  // 고정 크기 설정
                  width: double.maxFinite,
                  height: MediaQuery.of(context).size.height * 0.2,
                  child: isLoading
                      ? Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.deepPurple),
                    ),
                  )
                      : Form(
                    key: formKey,
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
                            controller: emailController,
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
                                CheckValidate().validate(
                                    focusNode: emailFocusNode,
                                    value: value!,
                                    emptytext: "이메일",
                                    lasttext: "이메일 형식",
                                    regExp: REGEXP.email
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                actions: <Widget>[
                  if (!isLoading)
                    TextButton(
                      onPressed: () async {
                        if (formKey.currentState!.validate()) {
                          setState(() => isLoading = true);
                          await Auth().sendPWResetEmail(email: emailController.text).then((result) {
                            setState(() => isLoading = false);
                            if (result == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('비밀번호 재설정 링크를 발송했습니다.', style: TextStyle(color: Colors.white)),
                                  backgroundColor: Colors.deepPurple,
                                ),
                              );
                              Navigator.of(dialogContext).pop();
                            } else {
                              ScaffoldMessenger.of(dialogContext).showSnackBar(
                                SnackBar(content: Text(result)),
                              );
                            }
                          });
                        }
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.deepPurple,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      ),
                      child: Text("확인", style: TextStyle(fontSize: 16)),
                    ),
                  if (!isLoading)
                    TextButton(
                      onPressed: () {
                        Navigator.of(dialogContext).pop();
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.grey,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      ),
                      child: Text("취소", style: TextStyle(fontSize: 16)),
                    ),
                ],
              );
            }
        );
      }
  );
}
