import 'package:flutter/material.dart';

import '../../../widgets/custom_button.dart';

class WaterWidget extends StatelessWidget {
  final double water;

  const WaterWidget({Key? key, required this.water})
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
                          "수분 섭취",
                          style: TextStyle(
                              color: Colors.blueGrey,
                              fontSize: 15),
                        ),
                        Icon(Icons.water_drop,)
                      ]),
                  const SizedBox(height: 25),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        "${water} ml",
                        style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                        overflow: TextOverflow.fade,
                        softWrap: false,
                      ),
                      Icon(Icons.local_drink)
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
                          "+ 200ml",
                          style: TextStyle(fontSize: 14),
                        ),
                      ))
                ])));
  }
}

