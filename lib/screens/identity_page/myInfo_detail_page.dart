import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import '../../utils/regExp.dart';
import '../../widgets/customForm.dart';

class MyInfoDetailPage extends StatefulWidget {
  const MyInfoDetailPage({Key? key}) : super(key: key);

  @override
  _MyInfoDetailPageState createState() => _MyInfoDetailPageState();
}

class _MyInfoDetailPageState extends State<MyInfoDetailPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List<String> data = [
    "닉네임",
    "이메일",
    "비밀번호",
    "나이",
    "성별",
    "키(cm)",
    "몸무게(kg)",
  ];
  late List<TextEditingController> controllers;
  late List<FocusNode> focusNodes;
  bool _showEditForm = false;

  @override
  void initState() {
    super.initState();
    controllers = List.generate(data.length, (index) => TextEditingController());
    focusNodes = List.generate(data.length, (index) => FocusNode());
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
      onPressed: () => setState(() => _showEditForm = !_showEditForm),
      child: Text(_showEditForm ? '폼 숨기기' : '정보 수정'),
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
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 1,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(15),
        margin: const EdgeInsets.only(top: 20),
        child: Form(
          key: _formKey,
          child: Column(
            children: List<Widget>.generate(data.length, (index) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: CustomForm().buildTextField(
                  label: data[index],
                  controller: controllers[index],
                  focusNode: focusNodes[index],
                  keyboardType: index == 3 || index > 4 ? TextInputType.number : TextInputType.text,
                  obscureText: data[index] == "비밀번호",
                  regExp: data[index] == "비밀번호" ? REGEXP.password : REGEXP.text,
                ),
              );
            })..add(
              ElevatedButton(
                onPressed: _handleFormSubmission,
                child: const Text('정보 저장'),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.deepPurple,
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRecentActivities() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text(
          '최근 활동',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        ListTile(
          leading: Icon(Icons.shopping_bag),
          title: Text('주문번호: 123456'),
          subtitle: Text('상품명: ABC 아이템'),
          trailing: Text('배송중'),
          onTap: null, // 주문 상세 페이지로 이동하는 코드 작성 예정
        ),
        ListTile(
          leading: Icon(Icons.login),
          title: Text('2024년 4월 24일 - 로그인 완료'),
        ),
      ],
    );
  }

  void _handleFormSubmission() {
    if (_formKey.currentState!.validate()) {
      // 폼 검증 성공
      _updateUserInfo();
    }
  }

  void _updateUserInfo() {
    // 서버나 데이터베이스에 정보를 업데이트하는 로직을 추가할 수 있습니다.
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('정보가 업데이트되었습니다.'))
    );
  }
}
