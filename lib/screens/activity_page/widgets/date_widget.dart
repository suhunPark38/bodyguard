import 'package:bodyguard/providers/health_data_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../providers/diet_data_provider.dart';
import '../../../providers/diet_provider.dart';

class DateWidget extends StatefulWidget {
  @override
  DateWidgetState createState() => DateWidgetState();
}

class DateWidgetState extends State<DateWidget> {

  @override
  Widget build(BuildContext context) {

    return Consumer2<HealthDataProvider, DietProvider>(
      builder: (context, provider, diet, child){
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded( // 이전 버튼 왼쪽 끝으로 밀어냄
              child: IconButton(
                icon: Icon(Icons.chevron_left, size: 28),
                onPressed: (){
                  provider.previousDate();
                  Provider.of<DietProvider>(context, listen: false).setSelectedDay(provider.selectedDate);
                  Provider.of<DietProvider>(context, listen: false).setFocusedDay(provider.selectedDate);
                  diet.notifySelectDiets(provider.selectedDate);
                },
              ),
            ),
            Text(
              DateFormat('M월 d일 EEEE', 'ko_KR').format(provider.selectedDate),
              style: const TextStyle(fontSize: 23), // 글꼴 크기 24
            ),
            Expanded( // 다음 버튼 오른쪽 끝으로 밀어냄
              child: IconButton(
                icon: const Icon(Icons.chevron_right, size: 28),
                onPressed: (){
                  print(provider.selectedDate);
                  provider.nextDate();
                  print(provider.selectedDate);
                  print("A");
                  Provider.of<DietProvider>(context, listen: false).setSelectedDay(provider.selectedDate);
                  Provider.of<DietProvider>(context, listen: false).setFocusedDay(provider.selectedDate);
                  diet.notifySelectDiets(provider.selectedDate);
                },
              ),
            ),

          ],
        );
      }
    );
  }

}
