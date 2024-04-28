import 'package:flutter/material.dart';



class QNAPage extends StatefulWidget {
  @override
  _QNAPageState createState() => _QNAPageState();
}

class _QNAPageState extends State<QNAPage> {
  final List<FAQ> _faqs = [
    FAQ(
      question: '앱을 어떻게 사용하나요?',
      answer: '앱을 사용하는 방법에 대한 자세한 내용은 사용자 매뉴얼을 참조하십시오.',
    ),
    FAQ(
      question: '계정을 어떻게 만들까요?',
      answer: '앱을 처음 실행하면 계정을 만들 수 있습니다.',
    ),
    FAQ(
      question: '비밀번호를 잊어버렸는데 어떻게요?',
      answer: '비밀번호 재설정 링크를 요청할 수 있습니다.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('자주 묻는 질문'),
      ),
      body: ListView.builder(
        itemCount: _faqs.length,
        itemBuilder: (context, index) {
          return ExpansionTile(
            title: Text(_faqs[index].question),
            children: [
              ListTile(
                title: Text(_faqs[index].answer),
              ),
            ],
          );
        },
      ),
    );
  }
}

class FAQ {
  final String question;
  final String answer;

  FAQ({required this.question, required this.answer});
}
