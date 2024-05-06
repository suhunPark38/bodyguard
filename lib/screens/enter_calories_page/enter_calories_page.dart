import 'package:bodyguard/database/config_database.dart';
import 'package:bodyguard/screens/enter_calories_page/widgets/diet_search_screen.dart';
import 'package:bodyguard/screens/enter_calories_page/widgets/diets_card.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import '../home_page/my_home_page.dart';
import 'package:bodyguard/providers/diet_provider.dart';
import 'package:provider/provider.dart';




class MyEnterCaloriesPage extends StatefulWidget {

  const MyEnterCaloriesPage({Key? key}) : super(key: key);

  @override
  MyEnterCaloriesPageState createState() => MyEnterCaloriesPageState();
}

class MyEnterCaloriesPageState extends State<MyEnterCaloriesPage> {
  final ConfigDatabase configDatabase = ConfigDatabase();

  late CalendarFormat _calendarFormat;
  late DateTime _focusedDay;
  late DateTime _selectedDay;

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
    DietProvider dietProvider = context.read<DietProvider>();
    dietProvider.notifySelectDiets(_selectedDay);
  }

  @override
  Widget build(BuildContext context) {
    DietProvider dietProvider = context.watch<DietProvider>();

    return ChangeNotifierProvider(
      create: (context) => dietProvider,
      child: Scaffold(
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
                  MaterialPageRoute(builder: (context) => const MyHomePage()),
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

                  },
                  headerStyle: const HeaderStyle(
                    formatButtonVisible: true,
                  ),
                  eventLoader: (day) {
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
                      ),
                      DietsCard(
                        title: "점심",
                      ),
                      DietsCard(
                        title: "저녁",
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
                                  '탄수화물 ${Provider.of<DietProvider>(context).totalNutritionalInfo.calories.toStringAsFixed(2)}g',
                                  style: const TextStyle(
                                      fontSize: 15, fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  '단백질 ${Provider.of<DietProvider>(context).totalNutritionalInfo.protein.toStringAsFixed(2)}g',
                                  style: const TextStyle(
                                      fontSize: 15, fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  '지방 ${Provider.of<DietProvider>(context).totalNutritionalInfo.fat.toStringAsFixed(2)}g',
                                  style: const TextStyle(
                                      fontSize: 15, fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  '나트륨 ${Provider.of<DietProvider>(context).totalNutritionalInfo.sodium.toStringAsFixed(2)}mg',
                                  style: const TextStyle(
                                      fontSize: 15, fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  '당 ${Provider.of<DietProvider>(context).totalNutritionalInfo.sugar.toStringAsFixed(2)}g',
                                  style: const TextStyle(
                                      fontSize: 15, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 20),
                                Text(
                                  '총 ${Provider.of<DietProvider>(context).totalNutritionalInfo.calories.toStringAsFixed(2)} kcal',
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
            onPressed: () => {
              Navigator.push(context, MaterialPageRoute(builder: (context) => DietSearchScreen()))
            },
            backgroundColor: Colors.blueAccent,
            child: const Icon(Icons.add),
          ),
        ),
      ),
    );
  }
}
