import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/diet_provider.dart';
import '../../../widgets/custom_button.dart';

class ReportWidget extends StatelessWidget {
  const ReportWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<DietProvider>(
      builder: (context, provider, child) {
        return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "식단 리포트",
                      style: const TextStyle(
                        color: Colors.blueGrey,
                        fontSize: 15,
                      ),
                    ),
                    Icon(Icons.bar_chart), // Using Material icon for bar chart
                  ],
                ),
                const SizedBox(height: 10),
                Text(provider.getWeeklyCaloriesComparisonMessage(provider.todayCalories, provider.averageCaloriesForWeek ),),
                const SizedBox(height: 10),
                Text(provider.getMonthlyCaloriesComparisonMessage(provider.todayCalories, provider.averageCaloriesForMonth ),),
                const SizedBox(height: 25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.3,
                      height: MediaQuery.of(context).size.height * 0.025,
                      child: CustomButton(
                        onPressed: () async {
                          _showBottomSheet(context, provider.todayCalories, provider.recommendedCalories, provider.averageCaloriesForWeek, provider.averageCaloriesForMonth);
                        },
                        text: const Text(
                          "확인하기",
                          style: TextStyle(fontSize: 10),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showBottomSheet(BuildContext context, double todayCalories, double recommendedCalories, double weekAverage, double monthAverage) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      isScrollControlled: true,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text(
                  "식단 리포트",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                // 주간 및 월간 평균 칼로리를 표시하는 그래프 추가
                Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        value: weekAverage / recommendedCalories,
                        backgroundColor: Colors.grey[300],
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.blueAccent),
                        minHeight: 10,
                      ),
                    ),
                    SizedBox(height: 10,),
                    Text(
                      '주간 평균: ${weekAverage.toStringAsFixed(1)} kcal',
                    ),
                    SizedBox(height: 10,),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        value: monthAverage / recommendedCalories,
                        backgroundColor: Colors.grey[300],
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.redAccent),
                        minHeight: 10,
                      ),
                    ),
                    SizedBox(height: 10,),
                    Text(
                      '월간 평균: ${monthAverage.toStringAsFixed(1)} kcal',
                    ),
                    SizedBox(height: 10,),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        value: todayCalories / recommendedCalories,
                        backgroundColor: Colors.grey[300],
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.teal),
                        minHeight: 10,
                      ),
                    ),
                    SizedBox(height: 10,),
                    Text(
                      '오늘 칼로리: ${todayCalories.toStringAsFixed(1)} kcal',
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                // 주간 및 월간 평균 칼로리에 대한 메시지 표시

                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("닫기"),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

}
