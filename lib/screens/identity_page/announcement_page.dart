import 'package:flutter/material.dart';

import '../../services/admin_firebase.dart';



class AnnouncementPage extends StatefulWidget {
  @override
  _AnnouncementPageState createState() => _AnnouncementPageState();
}

class _AnnouncementPageState extends State<AnnouncementPage> {
  List<Notice> notices = [
    Notice(title: '앱 출시 안내', content: '새로운 앱이 출시되었습니다!'),
    Notice(title: '업데이트 안내', content: '새로운 버전이 출시되었습니다. 지금 업데이트하세요!'),
    Notice(title: '이벤트 안내', content: '흥미진진한 이벤트가 진행 중입니다!'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('공지사항'),
      ),
      body: StreamBuilder<List<Map<String, String>>>(
        stream: AdminFirebase().announcement(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return CircularProgressIndicator();
            default:
              if (snapshot.hasData) {
                List<Map<String, String>> notice = snapshot.data!;
                return ListView.builder(
                  itemCount: notice.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: ListTile(
                        title: Text(notice[index]["Title"]!),
                        subtitle: Text(notice[index]["Content"]!),
                      ),
                    );
                  },
                );
              } else {
                return Text('No data available.');
              }
          }
        },
      )
    );
  }
}

class Notice {
  final String title;
  final String content;

  Notice({required this.title, required this.content});
}

class NoticeItem extends StatelessWidget {
  final Notice notice;

  NoticeItem({required this.notice});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(notice.title),
        subtitle: Text(notice.content),
      ),
    );
  }
}
