import 'package:flutter/material.dart';
import '../../services/admin_firebase.dart';

class AppInstructionsPage extends StatefulWidget {
  const AppInstructionsPage({Key? key}) : super(key: key);

  @override
  _AppInstructionsPage createState() => _AppInstructionsPage();
}

class _AppInstructionsPage extends State<AppInstructionsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('앱 사용 설명서'),
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: AdminFirebase().appInstructions(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Center(child: CircularProgressIndicator());
            default:
              if (snapshot.hasData) {
                List<Map<String, dynamic>> instructions = snapshot.data!;
                instructions.sort((a, b) {
                  String titleA = a["Title"] ?? "";
                  String titleB = b["Title"] ?? "";
                  return titleA.compareTo(titleB);
                });
                return ListView.builder(
                  itemCount: instructions.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(
                        instructions[index]["Title"]!,
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        instructions[index]["Text"]!,
                        style: TextStyle(fontSize: 16.0),
                      ),
                      isThreeLine: true,
                      onTap: () {}, // 상세 페이지나 다이얼로그를 여는 등의 액션 추가 가능
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
