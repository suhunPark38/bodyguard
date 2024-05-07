import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../services/activity_service.dart';
import '../../widgets/circle_chart.dart';
import '../home_page/my_home_page.dart';

class ActivityPage extends StatefulWidget {
  const ActivityPage({Key? key}) : super(key: key);

  @override
  _ActivityPageState createState() => _ActivityPageState();
}

class _ActivityPageState extends State<ActivityPage> {
  int _steps = 0; // 걸음 수를 저장할 변수 추가
  double weight = 70; // 사용자의 체중, 이 값은 사용자 입력으로 변경 가능
  double runningTime = 0; // 달리기한 시간(분), 이 값은 사용자 입력으로 변경 가능
  double caloriesBurned = 0;
  double bikingTime = 0; // 자전거를 탄 시간(분), 사용자 입력으로 변경됨
  double BcaloriesBurned = 0;
  double bikingSpeed = 2.5;

  bool _isRunningTimeVisible = false;
  bool _isBikingTimeVisible = false;

  ActivityService _activityService = ActivityService();

  Future<void> _updateActivityData() async {
    Map<String, dynamic> data = {
      'weight': weight,
      'runningTime': runningTime,
      'caloriesBurned': caloriesBurned,
      'bikingTime': bikingTime,
      'BcaloriesBurned': BcaloriesBurned,
      'steps': _steps,
    };
    await _activityService.updateActivityData(data);
  }

  Future<void> _incrementSteps() async {
    await _activityService.incrementSteps(_steps + 1);
    // 걸음 수가 증가되면 활동 데이터도 업데이트
    await _updateActivityData();
  }

  void _updateValues(double running, double biking) {
    setState(() {
      runningTime = running;
      bikingTime = biking;
      caloriesBurned = weight * runningTime / 60 * 3.5;
      BcaloriesBurned = weight * bikingTime * bikingSpeed / 60 * 4.0;

      // 다른 변수들이 업데이트되면 활동 데이터도 업데이트
      _updateActivityData();
    });
  }

  @override
  void initState() {
    super.initState();

    // 활동 데이터를 Firestore에서 읽어오기
    FirebaseFirestore.instance
        .collection('activity_data')
        .doc('user_activity')
        .snapshots()
        .listen((DocumentSnapshot snapshot) {
      if (snapshot.exists) {
        setState(() {
          weight = snapshot['weight'] ?? 70;
          runningTime = snapshot['runningTime'] ?? 0;
          caloriesBurned = snapshot['caloriesBurned'] ?? 0;
          bikingTime = snapshot['bikingTime'] ?? 0;
          BcaloriesBurned = snapshot['BcaloriesBurned'] ?? 0;
          _steps = snapshot['steps'] ?? 0;
        });
      } else {
        // 문서가 없으면 초기값으로 설정
        FirebaseFirestore.instance
            .collection('activity_data')
            .doc('user_activity')
            .set({
          'weight': 70,
          'runningTime': 0,
          'caloriesBurned': 0,
          'bikingTime': 0,
          'BcaloriesBurned': 0,
          'steps': 0,
        });
      }
    });
  }

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
                MaterialPageRoute(builder: (context) => MyHomePage()),
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
                            Text(
                              '${_steps * 0.04} kcal',
                              style: TextStyle(fontSize: 15),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                StepsDonutChart(
                                  steps: _steps,
                                ),
                                Text(
                                  "$_steps 보",
                                  style: TextStyle(fontSize: 15),
                                ),
                              ],
                            ),
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
                              '${(_steps * 0.001 * 0.7).toStringAsFixed(4)} km',
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
                      '$_steps 보',
                      style:
                          TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _incrementSteps,
                  child: Text('걸음 수 추가'),
                ),
                SizedBox(height: 30),
                _buildActivityRow(
                  icon: Icons.directions_run,
                  label: '달리기',
                  caloriesBurned: caloriesBurned,
                ),
                SizedBox(height: 10),
                _buildActivityRow(
                  icon: Icons.directions_bike,
                  label: '자전거',
                  caloriesBurned: BcaloriesBurned,
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return StatefulBuilder(
                    builder: (BuildContext context, StateSetter setState) {
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
                                      setState(() {
                                        _isRunningTimeVisible = true;
                                        _isBikingTimeVisible = false;
                                      });
                                    },
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.directions_run,
                                          color: _isRunningTimeVisible
                                              ? Colors.blue
                                              : Colors.grey,
                                        ),
                                        SizedBox(width: 10),
                                        Text(
                                          "달리기",
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: _isRunningTimeVisible
                                                ? Colors.black
                                                : Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: 20),
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        _isRunningTimeVisible = false;
                                        _isBikingTimeVisible = true;
                                      });
                                    },
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.directions_bike,
                                          color: _isBikingTimeVisible
                                              ? Colors.blue
                                              : Colors.grey,
                                        ),
                                        SizedBox(width: 10),
                                        Text(
                                          "자전거",
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: _isBikingTimeVisible
                                                ? Colors.black
                                                : Colors.grey,
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
                                    double running = double.parse(value);
                                    _updateValues(running, bikingTime);
                                  },
                                ),
                              if (_isBikingTimeVisible)
                                TextField(
                                  decoration: InputDecoration(
                                    hintText: "자전거 탄 시간(분)",
                                  ),
                                  keyboardType: TextInputType.number,
                                  onChanged: (value) {
                                    double biking = double.parse(value);
                                    _updateValues(runningTime, biking);
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
                    },
                  );
                },
              );
            },
            icon: Icon(Icons.add),
          ),
        ],
      ),

    );
  }

  Widget _buildInfoColumn({required String title, required String value}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 5),
        Text(
          value,
          style: TextStyle(fontSize: 15),
        ),
      ],
    );
  }

  Widget _buildActivityRow({
    required IconData icon,
    required String label,
    required double caloriesBurned,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 60),
        SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '오늘의 $label',
              style: TextStyle(fontSize: 15),
            ),
            SizedBox(height: 5),
            Text(
              '${caloriesBurned.toStringAsFixed(2)} kcal 소모',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ],
    );
  }
}

/*class ActivityPage extends StatefulWidget {
  const ActivityPage({Key? key}) : super(key: key);

  @override
  _ActivityPageState createState() => _ActivityPageState();
}

class _ActivityPageState extends State<ActivityPage> {
  DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    DateTime sunday = _selectedDate.subtract(Duration(days: _selectedDate.weekday - 1));
    DateTime saturday = sunday.add(const Duration(days: 6));*/
/*const Row(children:[Text("One week",style: TextStyle(color: Colors.blue),)]),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () {
                      setState(() {
                        _selectedDate = _selectedDate.subtract(const Duration(days: 7));
                      });
                    },
                    icon: const Icon(Icons.arrow_back_ios),
                  ),
                  Text(
                    '${sunday.month}월 ${sunday.day}일 - ${saturday.month}월 ${saturday.day}일',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 18),
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        _selectedDate = _selectedDate.add(const Duration(days: 7));
                      });
                    },
                    icon: const Icon(Icons.arrow_forward_ios),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              WeeklyStepsChart(),*/
class WeeklyStepsChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    int totalCalories = 1200;
    int totalDistance = 5; // in kilometers
    int totalSteps = 7000;
    int averageCalories = 1200;
    int averageDistance = 5; // in kilometers
    int averageSteps = 7000;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: List.generate(7, (index) {
              int steps = index * 1000;
              double height = steps / 1000 * 20;
              return Column(
                children: [
                  Text(
                    '$steps',
                    style: const TextStyle(fontSize: 12),
                  ),
                  const SizedBox(height: 5),
                  Container(
                    height: height,
                    width: 20,
                    color: Colors.blue,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    DateFormat('E', 'ko_KR').format(
                        DateTime.now().subtract(Duration(days: 6 - index))),
                    style: const TextStyle(fontSize: 12),
                  )
                ],
              );
            }),
          ),
          const SizedBox(width: 10),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const SizedBox(height: 20),
            Text(
              '총 소모 칼로리: $totalCalories kcal',
              style: const TextStyle(fontSize: 12),
            ),
            Text(
              '총 이동 거리: $totalDistance km',
              style: const TextStyle(fontSize: 12),
            ),
            Text(
              '총 걸음: $totalSteps 걸음',
              style: const TextStyle(fontSize: 12),
            ),
            Text(
              '평균 소모 칼로리: $averageCalories kcal',
              style: const TextStyle(fontSize: 12),
            ),
            Text(
              '평균 이동 거리: $averageDistance km',
              style: const TextStyle(fontSize: 12),
            ),
            Text(
              '평균 걸음: $averageSteps 걸음',
              style: const TextStyle(fontSize: 12),
            ),
          ]),
        ],
      ),
    );
  }
}
