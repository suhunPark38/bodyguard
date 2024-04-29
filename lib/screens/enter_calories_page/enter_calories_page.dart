import 'package:bodyguard/screens/enter_calories_page/widgets/diets_card.dart';
import 'package:drift/drift.dart' show Value;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:bodyguard/widgets/search.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:bodyguard/utils/calculateUtil.dart';

import 'package:bodyguard/database/configDatabase.dart';
import '../home_page/my_home_page.dart';

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
  ConfigDatabase _configDatabase = ConfigDatabase();

  late List<DietData> _diets = <DietData>[];

  late List<DietData> _breakfast;
  late List<DietData> _lunch;
  late List<DietData> _dinner;
  DietRecord _totalNutritionalInfo = DietRecord(
      calories: 0, carbohydrates: 0, protein: 0, fat: 0, sodium: 0, sugar: 0);

  @override
  void initState() {
    super.initState();
    DateTime now = DateTime.now();
    _focusedDay = DateTime.utc(now.year, now.month, now.day);
    _selectedDay = DateTime.utc(now.year, now.month, now.day);
    _calendarFormat = CalendarFormat.month;

    _setDiets();
  }

  // 화면 불러올 때, 식단 입력할 때, 날짜 바꿀 때 diets 정보 갱신하는 메소드
  Future<void> _setDiets() async {
    List<DietData> dietList =
        await _configDatabase.getDietByEatingTime(_selectedDay);

    setState(() {
      _diets = dietList;

      _breakfast = _diets.where((diet) => diet.classfication == 0).toList();
      _lunch = _diets.where((diet) => diet.classfication == 1).toList();
      _dinner = _diets.where((diet) => diet.classfication == 2).toList();

      _totalNutritionalInfo = DietRecord(
        calories: CalculateUtil()
            .getSumOfLists(_diets.map((diet) => diet.calories).toList()),
        carbohydrates: CalculateUtil()
            .getSumOfLists(_diets.map((diet) => diet.carbohydrate).toList()),
        protein: CalculateUtil()
            .getSumOfLists(_diets.map((diet) => diet.protein).toList()),
        fat: CalculateUtil()
            .getSumOfLists(_diets.map((diet) => diet.fat).toList()),
        sodium: CalculateUtil()
            .getSumOfLists(_diets.map((diet) => diet.sodium).toList()),
        sugar: CalculateUtil()
            .getSumOfLists(_diets.map((diet) => diet.sugar).toList()),
      );
    });
  }

  void _showSearchBar() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // 스크롤 가능 여부 설정 (true로 설정)
      builder: (context) => CustomSearchbar(),
    );
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
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                  });

                  _setDiets();

                  _totalNutritionalInfo = DietRecord(
                    calories: CalculateUtil().getSumOfLists(
                        _diets.map((diet) => diet.calories).toList()),
                    carbohydrates: CalculateUtil().getSumOfLists(
                        _diets.map((diet) => diet.carbohydrate).toList()),
                    protein: CalculateUtil().getSumOfLists(
                        _diets.map((diet) => diet.protein).toList()),
                    fat: CalculateUtil()
                        .getSumOfLists(_diets.map((diet) => diet.fat).toList()),
                    sodium: CalculateUtil().getSumOfLists(
                        _diets.map((diet) => diet.sodium).toList()),
                    sugar: CalculateUtil().getSumOfLists(
                        _diets.map((diet) => diet.sugar).toList()),
                  );
                },
                headerStyle: const HeaderStyle(
                  formatButtonVisible: true,
                ),
                eventLoader: (day) {
                  /*final nutritionalEvent = _configDatabase.getDietByEatingTime(_selectedDay);
                  if (nutritionalEvent != null) {
                    // 값이 입력된 경우 이벤트를 반환합니다.
                    return [nutritionalEvent];
                  } else {
                    // 값이 입력되지 않은 경우 null을 반환합니다.
                    return [];
                  }*/
                  return [];
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
                height: MediaQuery.of(context).size.height * 0.4,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    DietsCard(
                      title: "아침",
                      diets: _breakfast,
                    ),
                    DietsCard(
                      title: "점심",
                      diets: _lunch,
                    ),
                    DietsCard(
                      title: "저녁",
                      diets: _dinner,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 300,
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
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Text(
                                '먹은 칼로리',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 30),
                              Text(
                                '탄수화물 ${_totalNutritionalInfo.calories.toStringAsFixed(2)}g',
                                style: const TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                '단백질 ${_totalNutritionalInfo.protein.toStringAsFixed(2)}g',
                                style: const TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                '지방 ${_totalNutritionalInfo.fat.toStringAsFixed(2)}g',
                                style: const TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                '나트륨 ${_totalNutritionalInfo.sodium.toStringAsFixed(2)}mg',
                                style: const TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                '당 ${_totalNutritionalInfo.sugar.toStringAsFixed(2)}g',
                                style: const TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 20),
                              Text(
                                '총 ${_totalNutritionalInfo.calories.toStringAsFixed(2)} kcal',
                                style: const TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold),
                              ),
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
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Text(
                                '마신 물',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
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
            ],
          ),
        ),
      ),
      floatingActionButton: Positioned(
        bottom: 20,
        right: 20,
        child: FloatingActionButton(
          onPressed: () {
            _showSearchBar();
          },
          child: const Icon(Icons.add),
          backgroundColor: Colors.blueAccent,
        ),
      ),
    );
  }
}
