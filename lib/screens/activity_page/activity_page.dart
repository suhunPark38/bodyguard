import 'package:flutter/material.dart';
import '../../widgets/circle_chart.dart';
import '../home_page/my_home_page.dart';
import 'package:intl/intl.dart';

class ActivityPage extends StatefulWidget {
  const ActivityPage({Key? key}) : super(key: key);

  @override
  _ActivityPageState createState() => _ActivityPageState();
}

class _ActivityPageState extends State<ActivityPage> {
  DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    DateTime sunday = _selectedDate.subtract(Duration(days: _selectedDate.weekday - 1));
    DateTime saturday = sunday.add(const Duration(days: 6));

    return Scaffold(
      appBar: AppBar(
        title: const Text('활동'),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back),
        ),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const MyHomePage()),
                    (route) => false,
              );
            },
            icon: const Icon(Icons.home),
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Row(children:[Text("Today" ,style: TextStyle(color: Colors.blue),)]),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "${DateTime.now().month}월 ${DateTime.now().day}일 (${DateFormat('E', 'ko_KR').format(DateTime.now())})",
                    style: const TextStyle(fontSize: 20),
                  ),
                  const SizedBox(height: 30),
                  const Row(
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
                            '${1000 * 0.04}kcal',
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
                                steps: 4812,
                              ),
                              Text(
                                '4812 걸음',
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
                            '${1000 * 0.001 * 0.7}km',
                            style: TextStyle(fontSize: 15),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 30),
              const Row(children:[Text("One week",style: TextStyle(color: Colors.blue),)]),
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
              WeeklyStepsChart(),
            ],
          ),
        ),
      ),
    );
  }
}
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
                  DateFormat('E', 'ko_KR')
                      .format(DateTime.now().subtract(Duration(days: 6 - index))),
                  style: const TextStyle(fontSize: 12),
                )
              ],
            );
          }),
        ),
        const SizedBox(width: 10),
        Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
