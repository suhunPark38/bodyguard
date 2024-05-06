import 'package:bodyguard/model/diet_record.dart';
import 'package:bodyguard/providers/diet_provider.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';

class NutritionInfo extends StatefulWidget {
  const NutritionInfo({Key? key}) : super(key: key);

  @override
  _NutritionInfoState createState() => _NutritionInfoState();
}

class _NutritionInfoState extends State<NutritionInfo> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    DietRecord total = context.watch<DietProvider>().totalNutritionalInfo;
    double totalAmount = total.getTotalAmount();

    return LayoutBuilder(builder: (context, constraints) {
      return Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.black, width: 1)),
        child: Column(
          children: [
            Text(
              "영양 정보",
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            buildRow(totalAmount, total.carbohydrates, constraints, "탄수화물",
                Colors.pink),
            buildRow(
                totalAmount, total.protein, constraints, "단백질", Colors.yellow),
            buildRow(totalAmount, total.fat, constraints, "지방", Colors.blue),
          ],
        ),
      );
    });
  }

  Widget buildRow(double totalAmount, double nutrition,
      BoxConstraints constraints, String label, Color color) {
    return Row(
      children: [
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label),
              Text(
                '${nutrition.toStringAsFixed(2)} / ${totalAmount.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
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
                percent: nutrition / totalAmount,
                progressColor: color,
                center: Text(
                    "${(nutrition / totalAmount * 100).toStringAsFixed(1)} %"),
              )
            ],
          ),
        ),
      ],
    );
  }
}
