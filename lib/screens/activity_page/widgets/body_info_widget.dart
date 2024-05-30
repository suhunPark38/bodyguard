import 'package:bodyguard/providers/health_data_provider.dart';
import 'package:bodyguard/providers/user_info_provider.dart';
import 'package:bodyguard/widgets/custom_form.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../utils/regExp.dart';
import '../../../widgets/custom_button.dart';

class BodyInfoWidget extends StatelessWidget {
  const BodyInfoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;

    return GridView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
              child: Consumer<HealthDataProvider>(
                  builder: (context, provider, child) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "신장",
                          style:
                              TextStyle(color: Colors.blueGrey, fontSize: 15),
                        ),
                        Icon(Icons.accessibility),
                      ],
                    ),
                    const SizedBox(height: 25),
                    Text(
                      "${provider.height}cm",
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                      overflow: TextOverflow.fade,
                      softWrap: false,
                    ),
                    const SizedBox(height: 25),
                    SizedBox(
                      width: screenWidth * 0.3,
                      height: screenHeight * 0.025,
                      child: CustomButton(
                        onPressed: () {
                          showEditDialog(
                            Icons.accessibility,
                            context,
                            "신장",
                            provider.height.toString(),
                            (value) {
                              if (Provider.of<HealthDataProvider>(context,
                                          listen: false)
                                      .selectedDate
                                      .day ==
                                  DateTime.now().day) {
                                Provider.of<UserInfoProvider>(context,
                                        listen: false)
                                    .height = double.parse(value);
                              } else {
                                Provider.of<HealthDataProvider>(context,
                                        listen: false)
                                    .addHeightData(double.parse(value));
                              }
                            },
                          );
                        },
                        text: const Text(
                          "수정하기",
                          style: TextStyle(fontSize: 10),
                        ),
                      ),
                    ),
                  ],
                );
              })),
        ),
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
              padding: const EdgeInsets.all(16),
              child: Consumer<HealthDataProvider>(
                  builder: (context, provider, child) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "체중",
                          style:
                              TextStyle(color: Colors.blueGrey, fontSize: 15),
                        ),
                        Icon(Icons.monitor_weight),
                      ],
                    ),
                    const SizedBox(height: 25),
                    Text(
                      "${provider.weight}kg",
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                      overflow: TextOverflow.fade,
                      softWrap: false,
                    ),
                    const SizedBox(height: 25),
                    SizedBox(
                      width: screenWidth * 0.3,
                      height: screenHeight * 0.025,
                      child: CustomButton(
                        onPressed: () {
                          showEditDialog(
                            Icons.monitor_weight,
                            context,
                            "체중",
                            provider.weight.toString(),
                            (value) {
                              if (Provider.of<HealthDataProvider>(context,
                                          listen: false)
                                      .selectedDate
                                      .day ==
                                  DateTime.now().day) {
                                print("현재 시간과 동일");
                                Provider.of<UserInfoProvider>(context,
                                        listen: false)
                                    .weight = double.parse(value);
                              } else {
                                Provider.of<HealthDataProvider>(context,
                                        listen: false)
                                    .addWeightData(double.parse(value));
                              }
                            },
                          );
                        },
                        text: const Text(
                          "수정하기",
                          style: TextStyle(fontSize: 10),
                        ),
                      ),
                    ),
                  ],
                );
              })),
        ),
      ],
    );
  }

  void showEditDialog(IconData? icon, BuildContext context, String title,
      String initialValue, Function(String) onSave) {
    TextEditingController controller =
        TextEditingController(text: initialValue);
    FocusNode focusNode = FocusNode();

    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "$title 수정",
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Form(
            key: formKey,
            child: CustomForm().buildTextField(
              padding: const EdgeInsets.all(0),
              label: title,
              controller: controller,
              focusNode: focusNode,
              keyboardType: TextInputType.number,
              regExp: REGEXP.number,
            ),
          ),
          actions: [
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
                    if (formKey.currentState!.validate()) {
                      onSave(controller.text);
                      Navigator.of(context).pop();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
                  ),
                  child: const Text(
                    '수정하기',
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
