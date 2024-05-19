import 'package:flutter/material.dart';


class StepsWidget extends StatelessWidget {
  final int currentSteps; // 현재 걸음 수
  final int targetSteps; // 목표 걸음 수

  const StepsWidget({Key? key, required this.currentSteps, required this.targetSteps})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double percent = (currentSteps / targetSteps) * 100; // 달성도 계산

    return Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Row(
                      mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "걸음 수",
                          style: TextStyle(
                              color: Colors.blueGrey,
                              fontSize: 15),
                        ),
                        Icon(Icons.directions_walk)
                      ]),
                  const SizedBox(height: 25),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        "${currentSteps} 걸음",
                        style: const TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold),
                        overflow: TextOverflow.fade,
                        softWrap: false,
                      ),

                    ],
                  ),

                  const SizedBox(height: 25),
                ])));
  }


}



