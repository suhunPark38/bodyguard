import 'package:flutter/material.dart';

import 'donut_chart.dart';

class NutritionDonut extends StatelessWidget {
  final String label;
  final double recommendedAmount; // 권장량
  final double consumedAmount; // 섭취량

  const NutritionDonut({required this.label, required this.recommendedAmount, required this.consumedAmount});

  @override
  Widget build(BuildContext context) {
    final ratio = consumedAmount / recommendedAmount; // 비율 계산
    final remainingRatio = 1.0 - ratio; // 권장량 대비 남은 비율 계산

    return SizedBox(
      height: 200,
      width: 150,
      child: Column(
        children: [
          DonutChart(ratio: ratio),
          SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),

        ],
      ),
    );
  }
}