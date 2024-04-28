import 'package:flutter/material.dart';

class MyInfoDetailPage extends StatelessWidget {


  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
        title: Text('내 정보'),
    ),
    body:SingleChildScrollView(
      padding: EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 50,
            backgroundImage: NetworkImage('https://example.com/user_profile.jpg'),
          ),
          SizedBox(height: 20),
          Text(
            '사용자 이름: 사용자1',
            style: TextStyle(fontSize: 18),
          ),
          Text(
            '이메일: user@example.com',
            style: TextStyle(fontSize: 18),
          ),
          Text(
            '전화번호: 010-1234-5678',
            style: TextStyle(fontSize: 18),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // 사용자 정보 편집 페이지로 이동하는 코드 작성
            },
            child: Text('정보 수정'),
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
