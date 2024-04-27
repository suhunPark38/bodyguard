import 'package:flutter/material.dart';

import '../AddressChangePage/AddressChangePage.dart';
import '../search_page/search_page.dart';

class IdentityPage extends StatelessWidget {
  List<String> identityList = [
    '내정보',
    '내 주문 및 배송',
    '주소지 및 배송지 변경',
    '알림',
    '공지사항',
    '설정',
    '약관 및 정책',
    '앱 사용 도우미'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MY'),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(Icons.face, size: 40),
                Text(
                  '사용자1 님 안녕하세요.',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              itemCount: identityList.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailPage(identityList[index]),
                      ),
                    );
                  },
                  title: Container(child: Text(identityList[index])),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

/*class DetailPage extends StatelessWidget {
  final String detail;

  const DetailPage(this.detail, {super.key});

  @override
  Widget build(BuildContext context) {
    String content = '';
    if (detail == '내정보') {
      content = '여기에 사용자 정보를 표시합니다.';
    } else if (detail == '내 주문 및 배송') {
      content = '여기에 주문 내역과 배송 정보를 표시합니다.';
    } else if (detail == '주소지 및 배송지 변경') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AddressChangePage(), // 주소지 변경 페이지로 이동
        ),
      );
    } else if (detail == '알림') {
      content = '여기에 알림 관련 내용을 표시합니다.';
    } else if (detail == '공지사항') {
      content = '여기에 공지사항을 표시합니다.';
    } else if (detail == '설정') {
      content = '여기에 설정 관련 내용을 표시합니다.';
    } else if (detail == '약관 및 정책') {
      content = '여기에 약관 및 정책 내용을 표시합니다.';
    } else if (detail == '앱 사용 도우미') {
      content = '여기에 앱 사용 도우미 내용을 표시합니다.';
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(detail),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Text(
            content,
            style: const TextStyle(fontSize: 18),
          ),
        ),
      ),
    );
  }
}*/


class DetailPage extends StatelessWidget {
  final String detail;

  const DetailPage(this.detail, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget buildPageContent() {
      if (detail == '내정보') {
        return SingleChildScrollView(
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
        );
      } else if (detail == '내 주문 및 배송') {
        return Text('여기에 주문 내역과 배송 정보를 표시합니다.');
      } else if (detail == '주소지 및 배송지 변경') {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AddressChangePage(), // 주소지 변경 페이지로 이동
          ),
        );
      } else if (detail == '알림') {
        return Text('여기에 알림 관련 내용을 표시합니다.');
      } else if (detail == '공지사항') {
        return Text('여기에 공지사항을 표시합니다.');
      } else if (detail == '설정') {
        return Text('여기에 설정 관련 내용을 표시합니다.');
      } else if (detail == '약관 및 정책') {
        return Text('여기에 약관 및 정책 내용을 표시합니다.');
      } else if (detail == '앱 사용 도우미') {
        return Text('여기에 앱 사용 도우미 내용을 표시합니다.');
      }

      return Container(); // 모든 경우에 대해 기본적으로 빈 컨테이너를 반환합니다.
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(detail),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: buildPageContent(),
        ),
      ),
    );
  }
}


