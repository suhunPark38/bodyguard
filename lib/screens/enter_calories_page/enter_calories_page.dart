import 'package:bodyguard/database/config_database.dart';
import 'package:bodyguard/screens/enter_calories_page/widgets/diet_search_screen.dart';
import 'package:bodyguard/screens/enter_calories_page/widgets/diets_card.dart';
import 'package:bodyguard/widgets/nutrition_info.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import 'package:bodyguard/database/config_database.dart';
import '../../providers/today_health_data_provider.dart';
import '../my_home_page/my_home_page.dart';
import 'package:bodyguard/providers/diet_provider.dart';
import 'package:provider/provider.dart';




class EnterCaloriesPage extends StatefulWidget {

  const EnterCaloriesPage({Key? key}) : super(key: key);

  @override
  EnterCaloriesPageState createState() => EnterCaloriesPageState();
}

class EnterCaloriesPageState extends State<EnterCaloriesPage> {

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

    return Consumer<DietProvider>(builder: (context, provider, child) => Scaffold(
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
                  MaterialPageRoute(builder: (context) => const MyHomePage(initialIndex: 0,)),
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
                        classification: 0,
                      ),
                      DietsCard(
                        classification: 1,
                      ),
                      DietsCard(
                        classification: 2,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                const NutritionInfo(),
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
