import 'package:flutter/material.dart';

import '../../../widgets/custom_button.dart';


class BodyInfoWidget extends StatelessWidget {
  final double height; // 현재 걸음 수
  final double weight; // 목표 걸음 수

  const BodyInfoWidget({Key? key, required this.height, required this.weight})
      : super(key: key);

  @override
  Widget build(BuildContext context) {

    return GridView(
      shrinkWrap: true,
      gridDelegate:
      const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
      ),
      children: [
        Card(
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
                              "신장",
                              style: TextStyle(
                                  color: Colors.blueGrey,
                                  fontSize: 15),
                            ),
                            Icon(Icons.accessibility)
                          ]),
                      const SizedBox(height: 25),
                      Text(
                        "${height}cm",
                        style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                        overflow: TextOverflow.fade,
                        softWrap: false,
                      ),
                      const SizedBox(height: 25),
                      SizedBox(
                          width: 120,
                          height: 20,
                          child: CustomButton(
                            onPressed: () {

                            },
                            text: const Text(
                              "수정하기",
                              style: TextStyle(fontSize: 14),
                            ),
                          ))
                    ]))),
        Card(
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
                              "몸무게",
                              style: TextStyle(
                                  color: Colors.blueGrey,
                                  fontSize: 15),
                            ),
                            Icon(Icons.monitor_weight)
                          ]),
                      const SizedBox(height: 25),
                      Text(
                        "${weight}kg",
                        style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                        overflow: TextOverflow.fade,
                        softWrap: false,
                      ),
                      const SizedBox(height: 25),
                      SizedBox(
                          width: 120,
                          height: 20,
                          child: CustomButton(
                            onPressed: () {

                            },
                            text: const Text(
                              "수정하기",
                              style: TextStyle(fontSize: 14),
                            ),
                          ))
                    ]))),


      ],
    );
  }
}

