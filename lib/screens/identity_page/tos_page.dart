import 'package:flutter/material.dart';





class TOSPage extends StatefulWidget {
  @override
  _TOSPageState createState() => _TOSPageState();
}

class _TOSPageState extends State<TOSPage> {
  String terms = '약관 및 정책 내용을 여기에 입력합니다.';
  String policy = '개인정보 보호 정책 내용을 여기에 입력합니다.';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('약관 및 정책'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('약관', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 8.0),
              Text(terms, style: TextStyle(fontSize: 16.0)),
              SizedBox(height: 32.0),
              Text('개인정보 보호 정책', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 8.0),
              Text(policy, style: TextStyle(fontSize: 16.0)),
            ],
          ),
        ),
      ),
    );
  }
}
