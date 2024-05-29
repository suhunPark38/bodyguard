import 'package:bodyguard/providers/health_data_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
        child: SizedBox(
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
                            "수분 섭취",
                            style: TextStyle(
                                color: Colors.blueGrey,
                                fontSize: 15),
                          ),
                          Icon(Icons.water_drop,)
                        ]),
                    const SizedBox(height: 25),
                    // 아이콘 크기가 커져도 위젯 크기 변하지 않게 감싸줌.
                    SizedBox(
                        height: 80,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            GestureDetector(
                              onTap: () async {
                                final result = await showDialog<int>(
                                  context: context,
                                  builder: (context) {
                                    int inputValue = 0;
                                    return AlertDialog(
                                      title: const Text('물 추가하기'),
                                      content: TextField(
                                        autofocus: true,
                                        keyboardType: TextInputType.number,
                                        decoration: const InputDecoration(
                                          hintText: 'ml 입력',
                                        ),
                                        onChanged: (value) {
                                          inputValue = int.tryParse(value) ?? 0;
                                        },
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop(inputValue);
                                          },
                                          child: const Text('추가'),
                                        ),
                                      ],
                                    );
                                  },
                                );

                                if (result != null && result > 0) {
                                  Provider.of<HealthDataProvider>(context, listen: false)
                                      .addWaterData(result / 1000);
                                }
                              },
                              child: Text(
                                "${(water * 1000).toStringAsFixed(0)} ml",
                                style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                                overflow: TextOverflow.fade,
                                softWrap: false,
                              ),
                            ),
                            Icon(
                              Icons.local_drink,
                              size: water >= 2 ? 90 : (water >= 1 ? 60 : 30),
                              color: Colors.blue,
                            )
                          ],
                        )
                    ),
                    const SizedBox(height: 25),
                    SizedBox(
                        width: 150,
                        height: 20,
                        child: Consumer<HealthDataProvider>(
                            builder: (context, provider, _) => CustomButton(
                              onPressed: () {
                                provider.addWaterData(0.2);
                              },
                              text: const Text(
                                "+ 200ml",
                                style: TextStyle(fontSize: 14),
                              ),
                            )
                        )
                    )
                  ])),
        )
    );
  }
}
