import 'package:bodyguard/providers/health_data_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../providers/diet_provider.dart';
import '../../../widgets/custom_button.dart';

class DateWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    return Consumer<HealthDataProvider>(builder: (context, provider, child) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            // 이전 버튼 왼쪽 끝으로 밀어냄
            child: IconButton(
              icon: const Icon(Icons.chevron_left, size: 28),
      onPressed: (){
      provider.previousDate();
      Provider.of<DietProvider>(context, listen: false).setSelectedDay(provider.selectedDate);
      Provider.of<DietProvider>(context, listen: false).setFocusedDay(provider.selectedDate);
      Provider.of<DietProvider>(context, listen: false).notifySelectDiets(provider.selectedDate);
      },
            ),
          ),
          Text(
            DateFormat('M월 d일 EEEE', 'ko_KR').format(provider.selectedDate),
            style:   const TextStyle(fontSize: 18, fontWeight: FontWeight.w500), // 글꼴 크기 24
          ),
          Expanded(
            // 다음 버튼 오른쪽 끝으로 밀어냄
            child: IconButton(
              icon: const Icon(Icons.chevron_right, size: 28),
      onPressed: (){
                if(provider.isToday)
                  return;
                else{
      provider.nextDate();
      Provider.of<DietProvider>(context, listen: false).setSelectedDay(provider.selectedDate);
      Provider.of<DietProvider>(context, listen: false).setFocusedDay(provider.selectedDate);
      Provider.of<DietProvider>(context, listen: false).notifySelectDiets(provider.selectedDate);

      }

      },
            ),
          ),
          SizedBox(
            width: screenWidth * 0.3,
            height: screenHeight * 0.025,
            child: CustomButton(
              onPressed: () {
                provider.todayDate();
              },
              text: const Text(
                "오늘 날짜로",
                style: TextStyle(fontSize: 9),
              ),
            ),
          )
          ],
        );
      }
    );
  }

}
