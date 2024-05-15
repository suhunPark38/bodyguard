import 'package:flutter/material.dart';

import '../../services/auth_service.dart';
import '../../widgets/sign_up.dart';

class MyInfoDetailPage extends StatefulWidget {
  const MyInfoDetailPage({Key? key}) : super(key: key);

  @override
  _MyInfoDeailPage createState() => _MyInfoDeailPage();
}


class _MyInfoDeailPage extends State<MyInfoDetailPage>{
  @override
  Widget build(BuildContext context) {
    bool _showEditForm = false;


    return Scaffold(
        appBar: AppBar(
        title: Text('내 정보'),
    ),
    body:SingleChildScrollView(
      padding: EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              TextButton(
                  onPressed: (){
                    Auth().userLoginOut();
                    Navigator.pop(context);
                  },
                  child: Text("로그아웃")
              ),
            ],
          ),

          ElevatedButton(
            onPressed: () {
              setState(() {
                _showEditForm = !_showEditForm;  // 폼 보여주기 상태 토글
              });
            },
            child: Text(_showEditForm ? '폼 숨기기' : '정보 수정'),
          ),
          if (_showEditForm)
            Container(
              margin: EdgeInsets.only(top: 20),
              //child: SignUp(),  // SignUp 폼을 여기에 표시
            ),
          Divider(),
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
            onTap: () {
              // 주문 상세 페이지로 이동하는 코드 작성
            },
          ),
          ListTile(
            leading: Icon(Icons.login),
            title: Text('2024년 4월 24일 - 로그인 완료'),
          ),
        ],
      ),
    ),
    );
  }
}
