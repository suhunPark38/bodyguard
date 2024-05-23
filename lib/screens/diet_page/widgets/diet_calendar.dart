import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../database/config_database.dart';
import '../../../providers/diet_provider.dart';

class DietCalendar extends StatelessWidget {
  const DietCalendar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final koreanMonths = [
      '1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월'
    ];

    return Consumer<DietProvider>(
      builder: (context, provider, child) {
        return TableCalendar(
          firstDay: DateTime.utc(2024, 1, 1),
          lastDay: DateTime.utc(2025, 1, 1),
          focusedDay: provider.focusedDay,
          calendarFormat: provider.calendarFormat,
          daysOfWeekHeight: 30,
          selectedDayPredicate: (day) {
            return isSameDay(provider.selectedDay, day);
          },
          availableCalendarFormats: const {
            CalendarFormat.month: '월간',
            CalendarFormat.week: '주간',
          },
          onFormatChanged: (format) {
            provider.updateCalendarFormat(format);
          },
          onDaySelected: (selectedDay, focusedDay) {
            provider.setSelectedDay(selectedDay);
            provider.setFocusedDay(focusedDay);
            provider.notifySelectDiets(selectedDay);
          },
          headerStyle: const HeaderStyle(
            titleTextStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            formatButtonVisible: true,
            formatButtonShowsNext: false,
            leftChevronIcon: Icon(Icons.chevron_left, size: 28),
            rightChevronIcon: Icon(Icons.chevron_right, size: 28),
          ),
          calendarStyle: CalendarStyle(
            selectedDecoration: const BoxDecoration(
                color: Colors.teal, shape: BoxShape.circle),
            todayDecoration: BoxDecoration(
                color: Colors.teal.shade100, shape: BoxShape.circle),
          ),
          calendarBuilders: CalendarBuilders(
            dowBuilder: (context, day) {
              switch (day.weekday) {
                case 1:
                  return const Center(
                    child: Text(
                      '월',
                      style: TextStyle(color: Colors.black),
                    ),
                  );
                case 2:
                  return const Center(
                    child: Text(
                      '화',
                      style: TextStyle(color: Colors.black),
                    ),
                  );
                case 3:
                  return const Center(
                    child: Text(
                      '수',
                      style: TextStyle(color: Colors.black),
                    ),
                  );
                case 4:
                  return const Center(
                    child: Text(
                      '목',
                      style: TextStyle(color: Colors.black),
                    ),
                  );
                case 5:
                  return const Center(
                    child: Text(
                      '금',
                      style: TextStyle(color: Colors.black),
                    ),
                  );
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
            },
            markerBuilder: (context, day, events) {
              List<DietData> breakfastForDay = provider.breakfastForPeriod
                  .where((diet) => isSameDay(diet.eatingTime, day))
                  .toList();
              List<DietData> lunchForDay = provider.lunchForPeriod
                  .where((diet) => isSameDay(diet.eatingTime, day))
                  .toList();
              List<DietData> dinnerForDay = provider.dinnerForPeriod
                  .where((diet) => isSameDay(diet.eatingTime, day))
                  .toList();

              final hasBreakfast = breakfastForDay.isNotEmpty;
              final hasLunch = lunchForDay.isNotEmpty;
              final hasDinner = dinnerForDay.isNotEmpty;

              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  if (hasBreakfast)
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.orange,
                      ),
                    ),
                  if (hasLunch)
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.green,
                      ),
                    ),
                  if (hasDinner)
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.blue,
                      ),
                    ),
                ],
              );
            },
            headerTitleBuilder: (context, day) {
              return Center(
                child: Text(
                  '${day.year}년 ${koreanMonths[day.month - 1]}',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
