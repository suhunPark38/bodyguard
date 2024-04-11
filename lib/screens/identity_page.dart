import 'package:flutter/material.dart';

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

class DetailPage extends StatelessWidget {
  final String detail;

  const DetailPage(this.detail, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(detail),
      ),
      body: Center(
        child: Text(
          '$detail에 대한 세부 정보',
          style: const TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
