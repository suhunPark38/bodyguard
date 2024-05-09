import 'package:bodyguard/providers/diet_provider.dart';
import 'package:bodyguard/utils/calculate_util.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';

class CalorieInfoWidget extends StatefulWidget {
  const CalorieInfoWidget({Key? key}) : super(key: key);

  @override
  _CalorieInfoWidgetState createState() => _CalorieInfoWidgetState();
}

class _CalorieInfoWidgetState extends State<CalorieInfoWidget> {
  int targetCalories = 2000; // 목표 칼로리

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    /// 나중에 flutter_health 연동하면 안 쓸거임
    int currentCalories = CalculateUtil()
        .getSumOfLists(context
            .watch<DietProvider>()
            .diets
            .map((diet) => diet.calories)
            .toList())
        .floor();

    double progress = (currentCalories / targetCalories);
    double percent = progress < 1.0
        ? progress
        : 1.0; // progress가 1.0 이상일 경우 percentIndicator가 오류 발생. 따라서 최대 1.0으로 제한

    Color color = progress <= 0.3
        ? Colors.orange
        : progress <= 1
            ? Colors.green
            : Colors.red; // 달성도에 따라 그래프 색 바꿈.

    return LayoutBuilder(builder: (context, constraints) {
      return Container(
        child: Row(
          children: [
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${currentCalories} / $targetCalories',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text('(현재 섭취량 / 목표 섭취량)'),
                ],
              ),
            ),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  LinearPercentIndicator(
                    width: constraints.maxWidth > 400
                        ? 150
                        : constraints.maxWidth * 0.45,
                    lineHeight: 16,
                    barRadius: const Radius.circular(10),
                    animation: true,
                    percent: percent,
                    progressColor: color,
                    center: Text("${(progress * 100).toStringAsFixed(1)} %"),
                  )
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}
