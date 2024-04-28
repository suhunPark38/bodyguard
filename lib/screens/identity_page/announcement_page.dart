import 'package:flutter/material.dart';



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
      body: ListView.builder(
        itemCount: notices.length,
        itemBuilder: (context, index) {
          return NoticeItem(notice: notices[index]);
        },
      ),
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
