import 'package:bodyguard/providers/health_data_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class DateWidget extends StatefulWidget {
  @override
  DateWidgetState createState() => DateWidgetState();
}

class DateWidgetState extends State<DateWidget> {

  @override
  Widget build(BuildContext context) {

    return Consumer<HealthDataProvider>(
      builder: (context, provider, child){
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded( // 이전 버튼 왼쪽 끝으로 밀어냄
              child: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: provider.previousDate,
              ),
            ),
            Text(
              '${DateFormat('M월 d일 EEEE', 'ko_KR').format(provider.selectedDate)}',
              style: TextStyle(fontSize: 24), // 글꼴 크기 24
            ),
            Expanded( // 다음 버튼 오른쪽 끝으로 밀어냄
              child: IconButton(
                icon: Icon(Icons.arrow_forward),
                onPressed: provider.nextDate,
              ),
            ),

          ],
        );
      }
    );
  }

}
