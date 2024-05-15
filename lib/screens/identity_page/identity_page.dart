import 'package:bodyguard/providers/user_info_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/auth_service.dart';
import '../order_history_page/order_history_page.dart';
import 'appInstructions_page.dart';
import 'myInfo_detail_page.dart';
import '../address_change_page/address_change_page.dart';
import 'qna_page.dart';
import 'settings_page.dart';
import 'tos_page.dart';
import 'announcement_page.dart';
class IdentityPage extends StatefulWidget{
  const IdentityPage({Key? key}) : super(key: key);

  @override
  _IdentityPage createState() => _IdentityPage();
}

class _IdentityPage extends State<IdentityPage> {
  List<String> identityList = [
    '내정보',
    '결제 내역',
    '주소지 및 배송지 변경',
    '자주 묻는 질문',
    '약관 및 정책',
        '설정',
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
          Padding(
            padding: EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(Icons.face, size: 40),
                Consumer<UserInfoProvider>(
                    builder: (context ,userInfo, child){
                      return userInfo.D(" 님 안녕하세요.");
                    }),
                Spacer(),
                TextButton(
                  onPressed: () async {
                    Auth().userLoginOut();
                  },
                    child: Text("로그아웃")
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

class DetailPage extends StatelessWidget {
  final String detail;

  const DetailPage(this.detail, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget buildPageContent() {
      if (detail == '내정보') {
        return MyInfoDetailPage();
      } else if (detail == '결제 내역') {
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


