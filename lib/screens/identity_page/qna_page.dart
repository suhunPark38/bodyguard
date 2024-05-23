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
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Center(child: CircularProgressIndicator());
            default:
              if (snapshot.hasData) {
                List<Map<String, String>> qna = snapshot.data!;
                return ListView.separated(
                  itemCount: qna.length,
                  separatorBuilder: (context, index) => Divider(height: 1),
                  itemBuilder: (context, index) {
                    return ExpansionTile(
                      title: Text(
                        qna[index]['Question']!,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListTile(
                            title: Text(
                              qna[index]['Answer']!,
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                );
              } else {
                return Center(child: Text('No data available.'));
              }
          }
        },
      ),
    );
  }
}
