import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';



/*class ActPage extends StatefulWidget {
  @override
  _ActPageState createState() => _ActPageState();
}

class _ActPageState extends State<ActPage> {
  UserSteps _userSteps = UserSteps(steps: 0);

  @override
  void initState() {
    super.initState();
    // Firebase 초기화
    FirebaseFirestore.instance.settings = Settings(persistenceEnabled: false);
    // 실시간 업데이트 수신
    FirebaseFirestore.instance.collection('step_count').doc('user_steps').snapshots().listen((DocumentSnapshot snapshot) {
      if (snapshot.exists) {
        setState(() {
          _userSteps = UserSteps.fromMap(snapshot.data() as Map<String, dynamic>);
        });
      } else {
        // 문서가 없으면 초기값으로 문서 생성
        FirebaseFirestore.instance.collection('step_count').doc('user_steps').set({'steps': 0});
      }
    });
  }


  Future<void> _incrementSteps() async {
    try {
      await FirebaseFirestore.instance.collection('step_count').doc('user_steps').update({'steps': _userSteps.steps + 1});
    } catch (error) {
      print(error); // 디버깅을 위해 오류 출력
      // 여기에 사용자에게 오류 메시지를 표시하는 코드를 추가할 수 있습니다.
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('걸음 수 추적 앱'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              '걸음 수: ${_userSteps.steps}',
              style: TextStyle(fontSize: 32.0),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _incrementSteps,
              child: Text('걸음 수 추가'),
            ),
          ],
        ),
      ),
    );
  }
}*/




