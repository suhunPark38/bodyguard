import 'package:flutter/material.dart';
import '../OrderHistoryPage/OrderHistoryPage.dart';
import 'AppInstructions.dart';
import 'MyInfoDetailPage.dart';
import '../AddressChangePage/AddressChangePage.dart';
import 'Qna.dart';
import 'SettingsPage.dart';
import 'TOS.dart';
import 'announcement_page.dart';


class IdentityPage extends StatelessWidget {
  List<String> identityList = [
    '내정보',
    '내 주문 및 배송',
    '주소지 및 배송지 변경',
    '자주 묻는 질문',
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
        return MyInfoDetailPage();
      } else if (detail == '내 주문 및 배송') {
        return OrderHistoryPage();
      } else if (detail == '주소지 및 배송지 변경') {
        return AddressChangePage();
      } else if (detail == '자주 묻는 질문') {
        return QNAPage();
      } else if (detail == '공지사항') {
        return AnnouncementPage();
      } else if (detail == '설정') {
        return SettingsPage();
      } else if (detail == '약관 및 정책') {
        return TOSPage();
      } else if (detail == '앱 사용 도우미') {
        return AppInstructionsPage();
      }

      return Container(); // 모든 경우에 대해 기본적으로 빈 컨테이너를 반환합니다.
    }

    return Scaffold(

      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: buildPageContent(),
        ),
      ),
    );
  }
}


