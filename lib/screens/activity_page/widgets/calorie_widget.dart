import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';


class CalorieWidget extends StatelessWidget {
  final double targetCalories;
  final double burnedCalories;

  const CalorieWidget({Key? key, required this.burnedCalories, required this.targetCalories})
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
                          "칼로리 소모량",
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
                            "${burnedCalories.toStringAsFixed(1)}",
                            style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                            overflow: TextOverflow.fade,
                            softWrap: false,
                          ),
                          Text(
                            "/${targetCalories.toStringAsFixed(1)}kcal",
                            style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                            overflow: TextOverflow.fade,
                            softWrap: false,
                          ),
                        ],
                      ),
                      const SizedBox(height: 25),
                      _buildStepCircularChart(targetCalories, burnedCalories)
                    ],
                  ),
                  const SizedBox(height: 15,),
                  const Text(
                      "소모 칼로리 / 목표 칼로리",
                      style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold),
          overflow: TextOverflow.fade,
          softWrap: false,
        ),

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
        percent: (burnedCalories / targetCalories) >= 1 ? 1 : (burnedCalories / targetCalories),
        center: Text(
          '${(burnedCalories / (targetCalories == 0 ? 1 : targetCalories) * 100).toStringAsFixed(1)} %',
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
        ),
        circularStrokeCap: CircularStrokeCap.round,
        progressColor: Colors.red,
      );
  }
}

