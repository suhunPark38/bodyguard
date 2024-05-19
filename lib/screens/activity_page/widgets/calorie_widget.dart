import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../../../widgets/custom_button.dart';

class CalorieWidget extends StatelessWidget {
  final double targetCalorie;
  final double burnedCalorie;

  const CalorieWidget({Key? key, required this.burnedCalorie, required this.targetCalorie})
      : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child:  Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Row(
                      mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "소모 칼로리",
                          style: TextStyle(
                              color: Colors.blueGrey,
                              fontSize: 15),
                        ),
                        Icon(Icons.local_fire_department,)
                      ]),
                  const SizedBox(height: 25),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          Text(
                            "${burnedCalorie}",
                            style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                            overflow: TextOverflow.fade,
                            softWrap: false,
                          ),
                          Text(
                            "/${targetCalorie}Kcal",
                            style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                            overflow: TextOverflow.fade,
                            softWrap: false,
                          ),
                        ],
                      ),
                      const SizedBox(height: 25),
                      _buildStepCircularChart(2000, 150)
                    ],
                  ),
                  const SizedBox(height: 25),
                  SizedBox(
                      width: 150,
                      height: 20,
                      child: CustomButton(
                        onPressed: () {

                        },
                        text: const Text(
                          "칼로리 상세보기",
                          style: TextStyle(fontSize: 12),
                        ),
                      ))

                ])));
  }

  Widget _buildStepCircularChart(
      double targetCalories, double burnedCalories) {
    return
      CircularPercentIndicator(
        radius: 40.0,
        lineWidth: 6.0,
        animation: true,
        animationDuration: 1000,
        percent: burnedCalories / targetCalories,
        center: Text(
          '${(burnedCalories / targetCalories * 100).toStringAsFixed(1)} %',
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
        ),
        circularStrokeCap: CircularStrokeCap.round,
        progressColor: Colors.red,
      );
  }
}

