import 'package:bodyguard/utils.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/date_symbol_data_local.dart';



void main() {
  initializeDateFormatting().then((_) => runApp(const MyApp()));
}

class NutritionalData {
  final double calories;
  final double carbohydrates;
  final double protein;
  final double fat;
  final double sodium;
  final double sugar;
  final int waterIntake;
  final int steps;

  NutritionalData({
    required this.calories,
    required this.carbohydrates,
    required this.protein,
    required this.fat,
    required this.sodium,
    required this.sugar,
    required this.waterIntake,
    required this.steps,
  });
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late CalendarFormat _calendarFormat;
  late DateTime _focusedDay;
  late DateTime _selectedDay;

  Map<DateTime, NutritionalData> nutritionalData = {};

  @override
  void initState() {
    super.initState();
    DateTime now = DateTime.now();
    _focusedDay = DateTime.utc(now.year, now.month, now.day);
    _selectedDay = DateTime.utc(now.year, now.month, now.day);
    _calendarFormat = CalendarFormat.month;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '칼로리 입력',
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            print('뒤로가기 버튼 클릭됨!');
          },
          icon: const Icon(Icons.arrow_back),
        ),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              print('홈 버튼 클릭됨!');
            },
            icon: const Icon(Icons.home),
          ),
          IconButton(
            onPressed: () {
              setState(() {
                DateTime now = DateTime.now();
                _focusedDay = DateTime.utc(now.year, now.month, now.day);
                _selectedDay = DateTime.utc(now.year, now.month, now.day);
              });
            },
            icon: const Icon(Icons.today),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              TableCalendar(
                firstDay: DateTime.utc(2024, 1, 1),
                lastDay: DateTime.utc(2025, 1, 1),
                focusedDay: _focusedDay,
                calendarFormat: _calendarFormat,
                daysOfWeekHeight: 30,
                locale: 'ko-KR',
                selectedDayPredicate: (day) {
                  return isSameDay(_selectedDay, day);
                },
                availableCalendarFormats: {
                  CalendarFormat.week: '주간',
                  CalendarFormat.month: '월간',
                },
                onFormatChanged: (format) {
                  setState(() {
                    _calendarFormat = format;
                  });
                },
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                  });
                },
                headerStyle: const HeaderStyle(
                  formatButtonVisible: true,
                ),
                eventLoader: (day) {
                  final nutritionalEvent = nutritionalData[day];
                  if (nutritionalEvent != null) {
                    // 값이 입력된 경우 이벤트를 반환합니다.
                    return [nutritionalEvent];
                  } else {
                    // 값이 입력되지 않은 경우 null을 반환합니다.
                    return [];
                  }
                },
                calendarBuilders: CalendarBuilders(dowBuilder: (context, day) {
                  switch (day.weekday) {
                    case 6:
                      return const Center(
                        child: Text(
                          '토',
                          style: TextStyle(color: Colors.blue),
                        ),
                      );
                    case 7:
                      return const Center(
                        child: Text(
                          '일',
                          style: TextStyle(color: Colors.red),
                        ),
                      );
                  }
                }),
              ),

              ElevatedButton(

                onPressed: () {
                  print("음식 추가 버튼 클릭됨!!");
                },
                child: const Text('음식 추가'),
              ),

              const SizedBox(height: 20),
              SizedBox(
                height: 200,
                child: Row(

                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child:Card(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        elevation: 5,
                        child: const Padding(
                          padding: EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                '아침',
                                style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 30),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child:Card(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        elevation: 5,
                        child: const Padding(
                          padding: EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                '점심',
                                style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 30),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child:Card(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        elevation: 5,
                        child: const Padding(
                          padding: EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                '저녁',
                                style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 30),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              ElevatedButton(

                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext builder) {
                      String calories = '';
                      String carbohydrates = '';
                      String protein = '';
                      String fat = '';
                      String sodium = '';
                      String sugar = '';
                      String waterIntake = '';
                      String steps = '';

                      return AlertDialog(
                        title: const Text('값을 입력하세요'),
                        content: SingleChildScrollView(
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.7,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                TextField(
                                  onChanged: (value) {
                                    calories = value;
                                  },
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                    hintText: '칼로리 입력(type: double)',
                                  ),
                                ),
                                TextField(
                                  onChanged: (value) {
                                    carbohydrates = value;
                                  },
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                    hintText: '탄수화물 입력(type: double)',
                                  ),
                                ),
                                TextField(
                                  onChanged: (value) {
                                    protein = value;
                                  },
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                    hintText: '단백질 입력(type: double)',
                                  ),
                                ),
                                TextField(
                                  onChanged: (value) {
                                    fat = value;
                                  },
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                    hintText: '지방 입력(type: double)',
                                  ),
                                ),
                                TextField(
                                  onChanged: (value) {
                                    sodium = value;
                                  },
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                    hintText: '나트륨 입력(type: double)',
                                  ),
                                ),
                                TextField(
                                  onChanged: (value) {
                                    sugar = value;
                                  },
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                    hintText: '당 입력(type: double)',
                                  ),
                                ),
                                TextField(
                                  onChanged: (value) {
                                    waterIntake = value;
                                  },
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                    hintText: '마신 물 입력(type: int)',
                                  ),
                                ),
                                TextField(
                                  onChanged: (value) {
                                    steps = value;
                                  },
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                    hintText: '걸은 횟수 입력(type: int)',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        actions: <Widget>[
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                nutritionalData[_selectedDay] = NutritionalData(
                                  calories: double.tryParse(calories) ?? 0.0,
                                  carbohydrates:
                                      double.tryParse(carbohydrates) ?? 0.0,
                                  protein: double.tryParse(protein) ?? 0.0,
                                  fat: double.tryParse(fat) ?? 0.0,
                                  sodium: double.tryParse(sodium) ?? 0.0,
                                  sugar: double.tryParse(sugar) ?? 0.0,
                                  waterIntake: int.tryParse(waterIntake) ?? 0,
                                  steps: int.tryParse(steps) ?? 0,
                                );
                              });
                              Navigator.of(context).pop();
                            },
                            child: const Text('확인'),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: const Text('칼로리 및 성분 입력'),
              ),

              const SizedBox(height: 20),

              SizedBox(
                height: 300,
              child: Row(

                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                  child:Card(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    elevation: 5,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            '먹은 칼로리',
                            style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 30),
                          Text(
                            '탄수화물 ${nutritionalData[_selectedDay]?.carbohydrates ?? 0.0}g',
                            style: const TextStyle(fontSize: 15,fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '단백질 ${nutritionalData[_selectedDay]?.protein ?? 0.0}g',
                            style: const TextStyle(fontSize: 15,fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '지방 ${nutritionalData[_selectedDay]?.fat ?? 0.0}g',
                            style: const TextStyle(fontSize: 15,fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '나트륨 ${nutritionalData[_selectedDay]?.sodium ?? 0.0}mg',
                            style: const TextStyle(fontSize: 15,fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '당 ${nutritionalData[_selectedDay]?.sugar ?? 0.0}g',
                            style: const TextStyle(fontSize: 15,fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            '총 ${nutritionalData[_selectedDay]?.calories ?? 0.0} kcal',
                            style: const TextStyle(fontSize: 15,fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                  ),
                  Expanded(
                    child:
                  Card(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    elevation: 5,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            '마신 물',
                            style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 30),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if ((nutritionalData[_selectedDay]?.waterIntake ?? 0) >= 6)
                                const Icon(
                                  Icons.local_drink,
                                  size: 100, // 큰 아이콘 크기
                                  color: Colors.blue,
                                ),
                              if ((nutritionalData[_selectedDay]?.waterIntake ?? 0) >= 6)
                                const SizedBox(width: 5), // 물 컵 아이콘 간격 조절
                              if ((nutritionalData[_selectedDay]?.waterIntake ?? 0) < 6)
                                ...List.generate(
                                  (nutritionalData[_selectedDay]?.waterIntake?.toInt() ?? 0),
                                      (index) {
                                    return const Icon(
                                      Icons.local_drink,
                                      size: 20, // 작은 아이콘 크기
                                      color: Colors.blue,
                                    );
                                  },
                                ),
                            ],
                          ),
                          const SizedBox(height: 30),
                          Text(
                            '총 ${((nutritionalData[_selectedDay]?.waterIntake ?? 0) * 200) >= 1000 ? ((nutritionalData[_selectedDay]?.waterIntake ?? 0) * 200) / 1000 : (nutritionalData[_selectedDay]?.waterIntake ?? 0) * 200} ${(nutritionalData[_selectedDay]?.waterIntake ?? 0) * 200 >= 1000 ? "L" : "ml"}',
                            style: const TextStyle(fontSize: 15,fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                  ),
                ],
              ),
              ),

              const SizedBox(height: 20),

              Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                elevation: 5,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            '소모 칼로리',
                            style: TextStyle(fontSize: 15),
                          ),
                          Text(
                            '${(nutritionalData[_selectedDay]?.calories ?? 0.0) * 0.04}kcal',
                            style: const TextStyle(fontSize: 15),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            '활동량',
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10),
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              StepsDonutChart(steps: nutritionalData[_selectedDay]?.steps ?? 0),
                              Text(
                                '${(nutritionalData[_selectedDay]?.steps ?? 0)} 걸음',
                                style: const TextStyle(fontSize: 15),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            '이동한 거리',
                            style: TextStyle(fontSize: 15),
                          ),
                          Text(
                            '${((nutritionalData[_selectedDay]?.steps ?? 0.0) * 0.001 * 0.7).toStringAsFixed(1)}km',
                            style: const TextStyle(fontSize: 15),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
