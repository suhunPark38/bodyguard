import 'package:drift/drift.dart' show Value;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:bodyguard/util/DateUtil.dart';
import 'package:bodyguard/util/calculateUtil.dart';

import 'package:bodyguard/database/configDatabase.dart';
import 'package:bodyguard/widgets/circle_chart.dart';
import 'my_home_page.dart';

/// 사용자로부터 입력받은 식단 데이터
class DietRecord {
  double calories;
  double carbohydrates;
  double protein;
  double fat;
  double sodium;
  double sugar;

  DietRecord({
    required this.calories,
    required this.carbohydrates,
    required this.protein,
    required this.fat,
    required this.sodium,
    required this.sugar,
  });
}

class MyEnterCaloriesPage extends StatefulWidget {
  const MyEnterCaloriesPage({Key? key}) : super(key: key);

  @override
  _MyEnterCaloriesPageState createState() => _MyEnterCaloriesPageState();
}

class _MyEnterCaloriesPageState extends State<MyEnterCaloriesPage> {
  late CalendarFormat _calendarFormat;
  late DateTime _focusedDay;
  late DateTime _selectedDay;
  late ConfigDatabase _configDatabase;

  List<DietData> _diets = <DietData>[];

  late List<DietData> _breakfast;
  late List<DietData> _lunch;
  late List<DietData> _dinner;
  DietRecord _totalNutritionalInfo = DietRecord(calories: 0, carbohydrates: 0, protein: 0, fat: 0, sodium: 0, sugar: 0);

  @override
  void initState() {
    super.initState();
    DateTime now = DateTime.now();
    _focusedDay = DateTime.utc(now.year, now.month, now.day);
    _selectedDay = DateTime.utc(now.year, now.month, now.day);
    _calendarFormat = CalendarFormat.month;
    _configDatabase = ConfigDatabase();

    _breakfast = _diets.where((diet) => diet.classfication == 0).toList();
    _lunch = _diets.where((diet) => diet.classfication == 1).toList();
    _dinner = _diets.where((diet) => diet.classfication == 2).toList();
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
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back),
        ),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => MyHomePage()),
                (route) => false,
              );
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
                availableCalendarFormats: const {
                  CalendarFormat.week: '주간',
                  CalendarFormat.month: '월간',
                },
                onFormatChanged: (format) {
                  setState(() {
                    _calendarFormat = format;
                  });
                },
                onDaySelected: (selectedDay, focusedDay) async {
                  setState(()  {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;

                  });
                  _diets = await _configDatabase.getDietByEatingTime(_selectedDay);

                  _breakfast = _diets.where((diet) => diet.classfication == 0).toList();
                  _lunch = _diets.where((diet) => diet.classfication == 1).toList();
                  _dinner = _diets.where((diet) => diet.classfication == 2).toList();

                  _totalNutritionalInfo = DietRecord(
                      calories: CalculateUtil().getSumOfLists(_diets.map((diet) => diet.calories).toList()),
                      carbohydrates: CalculateUtil().getSumOfLists(_diets.map((diet) => diet.carbohydrate).toList()),
                      protein: CalculateUtil().getSumOfLists(_diets.map((diet) => diet.protein).toList()),
                      fat: CalculateUtil().getSumOfLists(_diets.map((diet) => diet.fat).toList()),
                      sodium: CalculateUtil().getSumOfLists(_diets.map((diet) => diet.sodium).toList()),
                      sugar: CalculateUtil().getSumOfLists(_diets.map((diet) => diet.sugar).toList()),
                  );

                  /// 확인 용. 완전 작업 끝나면 지울 것임.
                  print(_diets);


                },
                headerStyle: const HeaderStyle(
                  formatButtonVisible: true,
                ),
                eventLoader: (day) {
                  final nutritionalEvent = _configDatabase.getDietByEatingTime(_selectedDay);
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
                  return null;
                }),
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 200,
                child: Row(

                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: Card(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        elevation: 5,
                        child:  Padding(
                          padding: EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                '아침',
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                 _breakfast.map((diet) => diet.menuName).toString(),
                                style: const TextStyle(fontSize: 15),
                              ),
                              SizedBox(height: 30),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Card(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        elevation: 5,
                        child: Padding(
                          padding: EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                '점심',
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                _lunch.map((diet) => diet.menuName).toString(),
                                style: const TextStyle(fontSize: 15),
                              ),
                              SizedBox(height: 30),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Card(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        elevation: 5,
                        child: Padding(
                          padding: EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                '저녁',
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                _dinner.map((diet) => diet.menuName).toString(),
                                style: const TextStyle(fontSize: 15),
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
                      String amount = '';
                      String menuName = '';
                      String classification = '';
                      String eatingTime = '';

                      return AlertDialog(
                        title: const Text('값을 입력하세요'),
                        content: SingleChildScrollView(
                          child: SizedBox(
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
                                    menuName = value;
                                  },
                                  keyboardType: TextInputType.text,
                                  decoration: const InputDecoration(
                                    hintText: '메뉴 이름 입력(type: String)',
                                  ),
                                ),
                                TextField(
                                  onChanged: (value) {
                                    amount = value;
                                  },
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                    hintText: '먹은 양 입력(type: double)',
                                  ),
                                ),
                                TextField(
                                  onChanged: (value) {
                                    eatingTime = value;
                                  },
                                  keyboardType: TextInputType.text,
                                  decoration: const InputDecoration(
                                    hintText: '먹은 시간 입력(type: datetime)',
                                  ),
                                ),
                                TextField(
                                  onChanged: (value) {
                                    classification = value;
                                  },
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                    hintText: '식사 구분 입력(type: int) 0:아침',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        actions: <Widget>[
                          ElevatedButton(
                            onPressed: () {

                              _configDatabase.insertDiet(DietCompanion(
                                eatingTime: Value(DateTime.tryParse(eatingTime) ?? DateUtil().updateDateTimeToNow(_selectedDay)),
                                menuName: Value(menuName),
                                amount: Value(double.tryParse(amount) ?? 0.0),
                                classfication: Value(int.tryParse(classification) ?? 0),
                                calories: Value(double.tryParse(calories) ?? 0.0),
                                carbohydrate: Value(double.tryParse(carbohydrates) ?? 0.0),
                                protein: Value(double.tryParse(protein) ?? 0.0),
                                fat: Value(double.tryParse(fat) ?? 0.0),
                                sodium: Value(double.tryParse(sodium) ?? 0.0),
                                sugar: Value(double.tryParse(sugar) ?? 0.0),
                              ));

                              setState(() {

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
                            '탄수화물 ${_totalNutritionalInfo.calories}g',
                            style: const TextStyle(fontSize: 15,fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '단백질 ${_totalNutritionalInfo.protein}g',
                            style: const TextStyle(fontSize: 15,fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '지방 ${_totalNutritionalInfo.fat}g',
                            style: const TextStyle(fontSize: 15,fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '나트륨 ${_totalNutritionalInfo.sodium}mg',
                            style: const TextStyle(fontSize: 15,fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '당 ${_totalNutritionalInfo.sugar}g',
                            style: const TextStyle(fontSize: 15,fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            '총 ${_totalNutritionalInfo.calories} kcal',
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
                              if (0 >= 6)
                                const Icon(
                                  Icons.local_drink,
                                  size: 100, // 큰 아이콘 크기
                                  color: Colors.blue,
                                ),
                              if (0 >= 6)
                                const SizedBox(width: 5), // 물 컵 아이콘 간격 조절
                              if (0 < 6)
                                ...List.generate(
                                  (0),
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
                                '총 ${(0 * 200) >= 1000 ? (0 * 200) / 1000 : 0 * 200} ${0 * 200 >= 1000 ? "L" : "ml"}',
                                style: const TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold),
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
                            '${0.0}kcal',
                            style: const TextStyle(fontSize: 15),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            '활동량',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10),
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              StepsDonutChart(
                                  steps: 0),
                              Text(
                                '${0} 걸음',
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
                            '${(0 * 0.001 * 0.7).toStringAsFixed(1)}km',
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
