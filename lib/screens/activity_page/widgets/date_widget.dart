import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateWidget extends StatefulWidget {
  @override
  DateWidgetState createState() => DateWidgetState();
}

class DateWidgetState extends State<DateWidget> {
  DateTime _selectedDate = DateTime.now(); // 현재 선택된 날짜

  void _previousDate() {
    setState(() {
      _selectedDate = _selectedDate.subtract(const Duration(days: 1));
    });
  }

  void _nextDate() {
    setState(() {
      _selectedDate = _selectedDate.add(const Duration(days: 1));
    });
  }

  void _todayDate() {
    setState(() {
      _selectedDate = DateTime.now();
    });
  }

  @override
  Widget build(BuildContext context) {

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Expanded( // 이전 버튼 왼쪽 끝으로 밀어냄
          child: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: _previousDate,
          ),
        ),
        Text(
        '${DateFormat('M월 d일 EEEE', 'ko_KR').format(_selectedDate)}',
          style: TextStyle(fontSize: 24), // 글꼴 크기 24
        ),
        Expanded( // 다음 버튼 오른쪽 끝으로 밀어냄
          child: IconButton(
            icon: Icon(Icons.arrow_forward),
            onPressed: _nextDate,
          ),
        ),

      ],
    );
  }

}
