import 'package:bodyguard/providers/health_data_provider.dart';
import 'package:bodyguard/services/user_firebase.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';

import '../../../widgets/custom_button.dart';

class CalorieWidget extends StatelessWidget {
  final double burnedCalories;
  double targetCalorie;

  CalorieWidget(
      {Key? key, required this.burnedCalories, required this.targetCalorie})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;

    final provider = Provider.of<HealthDataProvider>(context);
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "소모 칼로리 / 목표 칼로리",
                    style: TextStyle(color: Colors.blueGrey, fontSize: 15),
                  ),
                  Icon(Icons.local_fire_department),
                ],
              ),
              const SizedBox(height: 25),
              Text(
                "${burnedCalories.toStringAsFixed(1)} / ${provider.targetCalorie} kcal",
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15),
              _buildStepCircularChart(provider.targetCalorie, burnedCalories),
              const SizedBox(height: 25),
              SizedBox(
                width: screenWidth * 0.4,
                height: screenHeight * 0.025,
                child: CustomButton(
                  onPressed: () {showCalorieSettingDialog(context);},
                  text: const Text(
                    "목표 칼로리 설정하기",
                    style: TextStyle(fontSize: 10),
                  ),
                ),
              ),
            ],
          ),
        ),

    );
  }

  Widget _buildStepCircularChart(double targetCalories, double burnedCalories) {
    return CircularPercentIndicator(
      radius: 40.0,
      lineWidth: 6.0,
      animation: true,
      animationDuration: 1000,
      percent: (burnedCalories / targetCalories).clamp(0, 1),
      center: Text(
        '${(100 * burnedCalories / targetCalories).clamp(0, 100).toStringAsFixed(1)}%',
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
      ),
      circularStrokeCap: CircularStrokeCap.round,
      progressColor: Colors.red,
    );
  }

  Future<double?> showCalorieSettingDialog(BuildContext context) {
    TextEditingController controller =
        TextEditingController(text: targetCalorie.toString());
    return showDialog<double>(
        context: context,
        builder: (context) {
          return StatefulBuilder(
            // StatefulBuilder를 사용하여 다이얼로그 내의 상태를 관리
            builder: (BuildContext context, StateSetter setState) {
              return AlertDialog(
                  title: const Text(
                    "목표 칼로리 설정",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: controller,
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: false),
                        decoration: const InputDecoration(
                          labelText: "목표 칼로리 (kcal)",
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) {
                          final newValue = double.tryParse(value);
                          if (newValue != null) {
                            setState(() {
                              // StatefulBuilder의 setState를 호출
                              targetCalorie = newValue; // 슬라이더 최대치를 넘지 않게 함
                            });
                          }
                        },
                      ),
                      Slider(
                        value: targetCalorie.clamp(500, 4000),
                        min: 500,
                        max: 4000,
                        divisions: 35,
                        label: targetCalorie.round().toString(),
                        onChanged: (double value) {
                          setState(() {
                            // StatefulBuilder의 setState를 호출
                            targetCalorie = value;
                            controller.text = value.toStringAsFixed(0);
                          });
                        },
                      ),
                    ],
                  ),
                  actions: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        FilledButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.grey.shade300,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 8.0),
                          ),
                          child: const Text(
                            '취소하기',
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ),
                        FilledButton(
                          onPressed: () {
                            double? newTarget =
                                double.tryParse(controller.text);
                            UserFirebase().updateTargetCalorie(newTarget!);
                            Navigator.of(context).pop(newTarget);
                          },
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 8.0),
                          ),
                          child: const Text(
                            '설정하기',
                          ),
                        ),
                      ],
                    )
                  ]);
            },
          );
        });
  }
}
