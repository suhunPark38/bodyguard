import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

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
  double bikingSpeed = 2.5;
  double BcaloriesBurned=0;

  bool _isRunningTimeVisible = false;
  bool _isBikingTimeVisible = false;

  void _updateValues(double running, double biking) {
    setState(() {
      runningTime = running;
      bikingTime = biking;
      caloriesBurned = weight * runningTime / 60 * 3.5;
      BcaloriesBurned = weight * bikingTime * bikingSpeed / 60 * 4.0;
    });
  }



  @override
  void initState() {
    super.initState();

    caloriesBurned = weight * runningTime / 60 * 3.5; // 소모 칼로리 계산


    // Firebase 초기화
    FirebaseFirestore.instance.settings = Settings(persistenceEnabled: false);
    // 실시간 업데이트 수신
    FirebaseFirestore.instance
        .collection('step_count')
        .doc('user_steps')
        .snapshots()
        .listen((DocumentSnapshot snapshot) {
      if (snapshot.exists) {
        setState(() {
          _steps =
              (snapshot.data() as Map<String, dynamic>)['steps']; // 걸음 수 업데이트
        });
      } else {
        // 문서가 없으면 초기값으로 문서 생성
        FirebaseFirestore.instance
            .collection('step_count')
            .doc('user_steps')
            .set({'steps': 0});
      }
    });
  }

  Future<void> _incrementSteps() async {
    try {
      await FirebaseFirestore.instance
          .collection('step_count')
          .doc('user_steps')
          .update({'steps': _steps + 1});
    } catch (error) {
      print(error); // 디버깅을 위해 오류 출력
      // 여기에 사용자에게 오류 메시지를 표시하는 코드를 추가할 수 있습니다.
    }
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
      body : SingleChildScrollView( // SingleChildScrollView로 전체 화면 감싸기
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
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
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '오늘의 걸음 수',
                      style:
                      TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.directions_walk, size: 60),
                        SizedBox(width: 10),
                        Text(
                          '$_steps 보', // 여기에 실제 걸음 수 표시
                          style: TextStyle(
                              fontSize: 40, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _incrementSteps, // 걸음 수 증가 버튼이 눌렸을 때의 동작
                      child: Text('걸음 수 추가'),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.directions_run, size: 60), // 달리기 아이콘 추가
                    SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          '오늘의 달리기(조깅)',
                          style: TextStyle(fontSize: 15),
                        ),
                        SizedBox(height: 5),
                        Text(
                          '${caloriesBurned.toStringAsFixed(2)} kcal 소모',
                          // 달리기에 따른 소모 칼로리 표시
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),

                      ],
                    ),
                  ],
                ),
                SizedBox(height: 10),


                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.directions_bike, size: 60), // 자전거 아이콘 추가
                    SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          '오늘의 자전거',
                          style: TextStyle(fontSize: 15),
                        ),
                        SizedBox(height: 5),
                        Text(
                          '${BcaloriesBurned.toStringAsFixed(2)} kcal 소모', // 자전거에 따른 소모 칼로리 표시
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),

                      ],
                    ),
                  ],
                ),
                SizedBox(height: 10),

                SizedBox(height: 20),

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
                  return AlertDialog(
                    title: Text("기록하기"),
                    content: StatefulBuilder(
                      builder: (BuildContext context, StateSetter setState) {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Column(
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
                                      Icon(Icons.directions_run),
                                      SizedBox(width: 10),
                                      Text(
                                        "달리기",
                                        style: TextStyle(fontSize: 16),
                                      ),
                                    ],
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      _isRunningTimeVisible = false;
                                      _isBikingTimeVisible = true;
                                    });
                                  },
                                  child: Row(
                                    children: [
                                      Icon(Icons.directions_bike),
                                      SizedBox(width: 10),
                                      Text(
                                        "자전거",
                                        style: TextStyle(fontSize: 16),
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

                              ],
                            ),
                          ],
                        );
                      },
                    ),
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
