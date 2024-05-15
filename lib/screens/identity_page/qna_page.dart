import 'package:flutter/material.dart';

import '../../services/admin_firebase.dart';



class QNAPage extends StatefulWidget {
  @override
  _QNAPageState createState() => _QNAPageState();
}

class _QNAPageState extends State<QNAPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('자주 묻는 질문'),
      ),
      body: StreamBuilder<List<Map<String, String>>>(
        stream: AdminFirebase().QNA(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return CircularProgressIndicator();
            default:
              if (snapshot.hasData) {
                List<Map<String, String>> qna = snapshot.data!;
                return ListView.builder(
                  itemCount: qna.length,
                  itemBuilder: (context, index) {
                    return ExpansionTile(
                      title: Text(qna[index]['Question']!),
                      children: [
                        ListTile(
                          title: Text(qna[index]['Answer']!),
                        ),
                      ],
                    );
                  },
                );
              } else {
                return Text('No data available.');
              }
          }
        },
      )
      ,
    );
  }
}

class FAQ {
  final String question;
  final String answer;

  FAQ({required this.question, required this.answer});
}

/*
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
      */