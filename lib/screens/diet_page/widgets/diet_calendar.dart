import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../providers/diet_provider.dart';

class DietCalendar extends StatelessWidget {
  const DietCalendar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<DietProvider>(
      builder: (context, provider, child) {
        return TableCalendar(
          firstDay: DateTime.utc(2024, 1, 1),
          lastDay: DateTime.utc(2025, 1, 1),
          focusedDay: provider.focusedDay,
          calendarFormat: provider.calendarFormat,
          daysOfWeekHeight: 30,
          locale: 'ko-KR',
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
            titleCentered: true,
            titleTextStyle:
                TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
            formatButtonVisible: true,
          ),
          calendarStyle:  CalendarStyle(
            selectedDecoration: BoxDecoration(
              color: Colors.teal,
              shape: BoxShape.circle
            ),
            todayDecoration: BoxDecoration(
              color: Colors.teal.shade100,
                shape: BoxShape.circle
            ),
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

        );
      },
    );
  }
}
