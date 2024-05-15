import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../my_home_page/my_home_page.dart';

import '../../model/activity_model.dart';



class ActivityPage extends StatefulWidget {
  const ActivityPage({Key? key}) : super(key: key);

  @override
  _ActivityPageState createState() => _ActivityPageState();
}

class _ActivityPageState extends State<ActivityPage> {



  @override
  Widget build(BuildContext context) {



    return Scaffold(
      appBar: AppBar(
        title: const Text('활동'),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const MyHomePage( initialIndex: 0,)),
                    (route) => false,
              );
            },
            icon: Icon(Icons.home),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            margin: EdgeInsets.all(20),
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.blueGrey[50],
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 3,
                  blurRadius: 7,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Row(children: [
                  Text(
                    "Today",
                    style: TextStyle(color: Colors.blue),
                  )
                ]),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "${DateTime.now().month}월 ${DateTime.now().day}일 (${DateFormat('E', 'ko_KR').format(DateTime.now())})",
                      style: const TextStyle(fontSize: 20),
                    ),
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              '소모 칼로리',
                              style: TextStyle(fontSize: 15),
                            ),

                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [

                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              '이동한 거리',
                              style: TextStyle(fontSize: 15),
                            ),
                            Text(
                              'km',
                              style: TextStyle(fontSize: 15),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                SizedBox(height: 30),
                Text(
                  '오늘의 걸음 수',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.directions_walk, size: 60),
                    SizedBox(width: 10),
                    Text(
                      '보',
                      style:
                      TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {

                  },
                  child: Text('걸음 수 추가'),
                ),
                SizedBox(height: 30),

                SizedBox(height: 10),

              ],
            ),
          ),
        ),
      ),

    );
  }
}


class ActivityRecordDialog extends StatefulWidget {
  final ActivityData activityData;

  const ActivityRecordDialog({Key? key, required this.activityData}) : super(key: key);

  @override
  _ActivityRecordDialogState createState() => _ActivityRecordDialogState();
}

class _ActivityRecordDialogState extends State<ActivityRecordDialog> {
  bool _isRunningTimeVisible = false;
  bool _isBikingTimeVisible = false;
  double runningTime = 0;
  double bikingTime = 0;




  void _toggleRunningTimeVisible() {
    setState(() {
      _isRunningTimeVisible = true;
      _isBikingTimeVisible = false;
    });
  }

  void _toggleBikingTimeVisible() {
    setState(() {
      _isRunningTimeVisible = false;
      _isBikingTimeVisible = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        "기록하기",
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.blue,
        ),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '활동 유형 선택',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Row(
              children: [
                InkWell(
                  onTap: () {
                    _toggleRunningTimeVisible();
                  },
                  child: Row(
                    children: [
                      Icon(
                        Icons.directions_run,
                        color: _isRunningTimeVisible ? Colors.blue : Colors.grey,
                      ),
                      SizedBox(width: 10),
                      Text(
                        "달리기",
                        style: TextStyle(
                          fontSize: 16,
                          color: _isRunningTimeVisible ? Colors.black : Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 20),
                InkWell(
                  onTap: () {
                    _toggleBikingTimeVisible();
                  },
                  child: Row(
                    children: [
                      Icon(
                        Icons.directions_bike,
                        color: _isBikingTimeVisible ? Colors.blue : Colors.grey,
                      ),
                      SizedBox(width: 10),
                      Text(
                        "자전거",
                        style: TextStyle(
                          fontSize: 16,
                          color: _isBikingTimeVisible ? Colors.black : Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            if (_isRunningTimeVisible)
              TextField(
                decoration: InputDecoration(
                  hintText: "달리기 시간(분)",
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  double runningTime = double.parse(value);
                },
              ),
            if (_isBikingTimeVisible)
              TextField(
                decoration: InputDecoration(
                  hintText: "자전거 탄 시간(분)",
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  double bikingTime = double.parse(value);
                },
              ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('취소'),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    // 여기에 입력을 처리하는 로직 추가
                    Navigator.pop(context);
                  },
                  child: Text('저장'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
