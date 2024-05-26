import 'package:flutter/material.dart';
import '../../model/user_model.dart';
import '../../services/auth_service.dart';
import '../../services/user_firebase.dart';
import '../../utils/format_util.dart';
import '../../utils/regExp.dart';
import '../../widgets/customForm.dart';
import '../../widgets/search_address.dart';

class MyInfoDetailPage extends StatefulWidget {
  const MyInfoDetailPage({Key? key}) : super(key: key);

  @override
  _MyInfoDetailPageState createState() => _MyInfoDetailPageState();
}

class _MyInfoDetailPageState extends State<MyInfoDetailPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
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
  bool _showEditForm = false;
  UserInfoModel? userInfo;

  @override
  void initState() {
    super.initState();
    controllers =
        List.generate(data.length, (index) => TextEditingController());
    focusNodes = List.generate(data.length, (index) => FocusNode());
    _initializeUserInfo();
  }

  Future<void> _initializeUserInfo() async {
    userInfo = await UserFirebase().getUserInfoF();
    if (userInfo != null) {
      setState(() {
        controllers[0].text = userInfo!.nickName;
        controllers[1].text = userInfo!.email;
        controllers[3].text = (userInfo!.age).toString();
        controllers[4].text = userInfo!.gender;
        controllers[5].text = userInfo!.height.toString();
        controllers[6].text = userInfo!.weight.toString();
        controllers[7].text = userInfo!.roadAddress;
        controllers[8].text = userInfo!.detailAddress;
      });
    }
  }

  @override
  void dispose() {
    controllers.forEach((controller) => controller.dispose());
    focusNodes.forEach((focusNode) => focusNode.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('내 정보'),
        elevation: 0,
      ),
      body: AnimatedContainer(
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: <Widget>[
            _buildLogoutButton(),
            const SizedBox(height: 20),
            _buildToggleEditFormButton(),
            const SizedBox(height: 20),
            if (_showEditForm) _buildEditForm(),
            const Divider(height: 40, thickness: 2),
            _buildRecentActivities(),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoutButton() {
    return Align(
      alignment: Alignment.centerRight,
      child: OutlinedButton(
        onPressed: () {
          Auth().userLoginOut();
          Navigator.pop(context);
        },
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: Colors.redAccent),
        ),
        child: const Text("로그아웃", style: TextStyle(color: Colors.redAccent)),
      ),
    );
  }

  Widget _buildToggleEditFormButton() {
    return ElevatedButton(
      onPressed: () => setState(() {
        _showEditForm = !_showEditForm;
      }),
      child: Text(_showEditForm ? '정보 숨기기' : '정보 수정'),
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.deepPurple,
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }

  Widget _buildEditForm() {
    return AnimatedOpacity(
        opacity: _showEditForm ? 1.0 : 0.0,
        duration: Duration(milliseconds: 500),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2), // 부드러운 회색 그림자
                spreadRadius: 1,
                blurRadius: 10,
                offset: Offset(0, 4), // 약간의 입체감을 위해 y축으로 조금 이동
              )
            ],
          ),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildSectionTitle("기본 정보"),
                const SizedBox(height: 10),
                CustomForm().buildTextField(
                  label: data[0],
                  // 닉네임
                  controller: controllers[0],
                  focusNode: focusNodes[0],
                  regExp: REGEXP.text,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                ),
                const SizedBox(height: 10),
                CustomForm().buildTextField(
                  label: data[1],
                  // 이메일
                  controller: controllers[1],
                  focusNode: focusNodes[1],
                  keyboardType: TextInputType.emailAddress,
                  readOnly: true,
                  regExp: REGEXP.email,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                ),
                const SizedBox(height: 10),
                CustomForm().buildTextField(
                  label: data[2],
                  // 비밀번호
                  controller: controllers[2],
                  focusNode: focusNodes[2],
                  obscureText: true,
                  keyboardType: TextInputType.visiblePassword,
                  regExp: REGEXP.password,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  validator: (value) {
                    if (CheckValidate().checkPW(
                                focusNode: focusNodes[2], value: value!) ==
                            null &&
                        value.isNotEmpty) {
                      Auth().updatePassword(value);
                      return null;
                    } else if (value.isEmpty) {
                      return null;
                    }
                    return "6자 이상 입력하세요";
                  },
                ),
                const SizedBox(height: 10),
                CustomForm().buildTextField(
                  label: data[3],
                  // 나이
                  controller: controllers[3],
                  focusNode: focusNodes[3],
                  keyboardType: TextInputType.number,
                  regExp: REGEXP.age,
                  errorText: "나이가 너무 많습니다.",
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                ),
                _buildSectionDivider(),
                _buildSectionTitle("신체 정보"),
                const SizedBox(height: 10),
                CustomForm().buildTextField(
                  label: data[5],
                  // 키
                  controller: controllers[5],
                  focusNode: focusNodes[5],
                  keyboardType: TextInputType.number,
                  regExp: REGEXP.number,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                ),
                const SizedBox(height: 20),
                CustomForm().buildTextField(
                  label: data[6],
                  // 몸무게
                  controller: controllers[6],
                  focusNode: focusNodes[6],
                  regExp: REGEXP.number,
                  keyboardType: TextInputType.number,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                ),
                const SizedBox(
                  height: 5,
                ),
                CustomForm().genderSelectField(
                  controller: controllers[4],
                  context: context,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                ),
                _buildSectionDivider(),
                _buildSectionTitle("주소 정보"),
                const SizedBox(height: 5),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextFormField(
                    controller: controllers[7],
                    focusNode: focusNodes[7],
                    readOnly: true,
                    decoration: CustomForm().buildDefaultDecoration(
                        labelText: data[7], isReadOnly: true),
                    onTap: () async {
                      selectedadress = await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SearchAddress()),
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
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
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
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      setState(() {
                        isLoading = true;
                      });
                      userInfo!.nickName = controllers[0].text;
                      userInfo!.email = controllers[1].text;
                      userInfo!.age =
                          int.parse(controllers[3].text); // 문자열을 int로 변환
                      userInfo!.gender = controllers[4].text;
                      userInfo!.height =
                          double.parse(controllers[5].text); // 문자열을 double로 변환
                      userInfo!.weight =
                          double.parse(controllers[6].text); // 문자열을 double로 변환
                      if (userInfo!.roadAddress != controllers[7].text) {
                        userInfo!.NLatLng = [
                          selectedadress!['x'],
                          selectedadress!['y']
                        ];
                      }
                      userInfo!.roadAddress = controllers[7].text;
                      userInfo!.detailAddress = controllers[8].text;
                      String? result =
                          await UserFirebase().updateUser(user: userInfo!);
                      if (result == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("정보가 성공적으로 저장되었습니다.")));
                      } else {
                        print(result);
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
                      : Text("수정 완료"),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.deepPurple,
                    backgroundColor: Colors.blueGrey[100],
                    // 깔끔하면서도 세련된 색상 유지
                    minimumSize: Size(200, 45),
                    // 크기를 조금 더 슬림하게 조정
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(12), // 모서리 둥근 정도를 적당히 줄여 깔끔하게
                    ),
                    elevation: 0, //
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ));
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: Colors.deepPurple,
      ),
    );
  }

  Widget _buildSectionDivider() {
    return Container(
      height: 2,
      color: Colors.deepPurple,
      margin: EdgeInsets.symmetric(vertical: 20),
    );
  }

  Widget _buildRecentActivities() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '최근 활동',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        // ListTile(
        //   leading: Icon(Icons.shopping_bag),
        //   title: Text('주문번호: 123456'),
        //   subtitle: Text('상품명: ABC 아이템'),
        //   trailing: Text('배송중'),
        //   onTap: null, // 주문 상세 페이지로 이동하는 코드 작성 예정
        // ),
        ListTile(
          leading: Icon(Icons.login),
          title: Text(
              "마지막 로그인 시간 \n${formatTimestamp((userInfo!.time).toDate())}"),
        ),
      ],
    );
  }
}
