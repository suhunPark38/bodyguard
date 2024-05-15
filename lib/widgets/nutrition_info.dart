import 'package:bodyguard/model/diet_record.dart';
import 'package:bodyguard/providers/diet_provider.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';

class NutritionInfo extends StatelessWidget {
  const NutritionInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DietRecord total = context.watch<DietProvider>().totalNutritionalInfo;
    double totalAmount = total.getTotalAmount();

    return LayoutBuilder(builder: (context, constraints) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          buildCircularChart(
              totalAmount, total.carbohydrates, "탄수화물", Colors.pink),
          buildCircularChart(totalAmount, total.protein, "단백질", Colors.yellow),
          buildCircularChart(totalAmount, total.fat, "지방", Colors.blue),
        ],
      );
    });
  }

  Widget buildCircularChart(
      double totalAmount, double nutrition, String label, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CircularPercentIndicator(
          radius: 40.0,
          lineWidth: 6.0,
          animation: true,
          animationDuration: 1000,
          percent: nutrition / totalAmount,
          center: Text(
            '${(nutrition / totalAmount * 100).toStringAsFixed(1)} %',
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          ),
          circularStrokeCap: CircularStrokeCap.round,
          progressColor: color,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text('$label (g)', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: Text(
            '${nutrition.toStringAsFixed(1)} / ${totalAmount.toStringAsFixed(1)}',
            style: const TextStyle(
              fontSize: 12,
                fontWeight: FontWeight.w500
            ),
          ),
        ),
      ],
    );
  }
}
