import 'package:bodyguard/providers/health_data_provider.dart';
import 'package:bodyguard/providers/user_info_provider.dart';
import 'package:bodyguard/widgets/customForm.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../utils/regExp.dart';
import '../../../widgets/custom_button.dart';

class BodyInfoWidget extends StatefulWidget {
  BodyInfoWidget({Key? key}) : super(key: key);

  @override
  _BodyInfoWidget createState() => _BodyInfoWidget();
}
class _BodyInfoWidget extends State<BodyInfoWidget>{
  @override
  Widget build(BuildContext context) {
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
                builder: (context, provider, child){
                  return Column(
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
                        width: 110,
                        height: 20,
                        child: CustomButton(
                          onPressed: () {
                            showEditDialog(
                              Icons.accessibility,
                              context,
                              "신장",
                              provider.height.toString(),
                                  (value) {
                                Provider.of<UserInfoProvider>(context, listen: false).height = double.parse(value);
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
                })
            ),
          ),
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Consumer<HealthDataProvider>(
                builder: (context, provider, child){
                  return Column(
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
                        width: 110,
                        height: 20,
                        child: CustomButton(
                          onPressed: () {
                            showEditDialog(
                              Icons.monitor_weight,
                              context,
                              "몸무게",
                              provider.weight.toString(),
                                  (value) {
                                    Provider.of<UserInfoProvider>(context, listen: false).weight = double.parse(value);
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
                })
            ),
          ),
        ],
      );
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
                FilledButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      onSave(controller.text);
                      print(controller.text);
                      Navigator.of(context).pop();
                    }
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.grey.shade300,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
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
                    if (_formKey.currentState!.validate()) {
                      onSave(controller.text);
                      print(controller.text);
                      Navigator.of(context).pop();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
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
