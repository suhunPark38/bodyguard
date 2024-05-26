import 'package:bodyguard/providers/health_data_provider.dart';
import 'package:bodyguard/widgets/customForm.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../utils/regExp.dart';
import '../../../widgets/custom_button.dart';

class BodyInfoWidget extends StatelessWidget {
  final double height; // 현재 걸음 수
  final double weight; // 목표 걸음 수
  const BodyInfoWidget({Key? key, required this.height, required this.weight})
      : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Consumer<HealthDataProvider>(builder: (context, provider, child) {
      return GridView(
        shrinkWrap: true,
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "신장",
                        style: TextStyle(color: Colors.blueGrey, fontSize: 15),
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
                    width: 120,
                    height: 20,
                    child: CustomButton(
                      onPressed: () {
                        showEditDialog(
                          Icons.accessibility,
                          context,
                          "신장",
                          provider.height.toString(),
                          (value) {
                            provider.height = double.parse(value);
                          },
                        );
                      },
                      text: const Text(
                        "수정하기",
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "몸무게",
                        style: TextStyle(color: Colors.blueGrey, fontSize: 15),
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
                    width: 120,
                    height: 20,
                    child: CustomButton(
                      onPressed: () {
                        showEditDialog(
                          Icons.monitor_weight,
                          context,
                          "몸무게",
                          provider.weight.toString(),
                          (value) {
                            provider.weight = double.parse(value);
                          },
                        );
                      },
                      text: const Text(
                        "수정하기",
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    });
  }

  void showEditDialog(IconData? icon, BuildContext context, String title,
      String initialValue, Function(String) onSave) {
    TextEditingController controller =
        TextEditingController(text: initialValue);
    FocusNode focusNode = FocusNode();

    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          title: Text(
            "$title 수정",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.blueAccent,
            ),
          ),
          content: Form(
            key: _formKey,
            child: CustomForm().buildTextField(
              padding: EdgeInsets.all(0),
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
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      onSave(controller.text);
                      print(controller.text);
                      Navigator.of(context).pop();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.blueAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  ),
                  child: Text(
                    '저장',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.redAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  ),
                  child: Text(
                    '취소',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
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
