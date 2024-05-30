import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bodyguard/model/fetched_diet_data.dart';
import 'package:bodyguard/providers/diet_data_provider.dart';
import 'package:bodyguard/providers/diet_provider.dart';
import 'package:bodyguard/database/local_database.dart';

import '../screens/my_home_page/my_home_page.dart';
import '../utils/format_util.dart';
import 'custom_button.dart';

class DietInputSheet extends StatelessWidget {
  final FetchedDietData selectedData;

  const DietInputSheet({Key? key, required this.selectedData})
      : super(key: key);

  static Future<void> show(BuildContext context, FetchedDietData selectedData) {
    return showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      isScrollControlled: true,
      builder: (context) => ChangeNotifierProvider(
        create: (_) => DietDataProvider(),
        child: DietInputSheet(selectedData: selectedData),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Row(
                    children: [
                      Flexible(
                        child: Text(
                          selectedData.DESC_KOR,
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Card(
                        child: Padding(
                          padding: EdgeInsets.all(4.0),
                          child: Text(
                            "기록중",
                            style: TextStyle(
                                fontSize: 14, color: Colors.deepPurpleAccent),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(children: [
              const Text("섭취량",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(
                width: 5,
              ),
              Text("1회 제공량 기준",
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade600))
            ]),
            Consumer<DietDataProvider>(
              builder: (context, provider, child) {
                return Column(
                  children: [
                    Text(
                      provider.amount.toStringAsFixed(1),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Slider(
                      value: provider.amount,
                      min: 0.0,
                      max: 10.0,
                      divisions: 100,
                      label: provider.amount.toStringAsFixed(1),
                      onChanged: (double newValue) {
                        provider.setAmount(newValue);
                      },
                    ),
                    const SizedBox(height: 10),
                    const Row(children: [
                      Text("식사 시간",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                    ]),
                    const SizedBox(height: 5),
                    SegmentedButton<int>(
                      segments: const <ButtonSegment<int>>[
                        ButtonSegment<int>(
                          value: 0,
                          label: Text('아침'),
                        ),
                        ButtonSegment<int>(
                          value: 1,
                          label: Text('점심'),
                        ),
                        ButtonSegment<int>(
                          value: 2,
                          label: Text('저녁'),
                        )
                      ],
                      selected: <int>{provider.classification},
                      onSelectionChanged: (selected) {
                        provider.setClassification(selected.first);
                      },
                    ),
                    const SizedBox(height: 10),
                    const Row(children: [
                      Text("상세 시간",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                    ]),
                    TextButton(
                      onPressed: () async {
                        final selectedDate = await showDatePicker(
                          context: context,
                          initialDate: provider.eatingTime,
                          firstDate: DateTime(2023),
                          lastDate: DateTime.now(),
                        );

                        if (selectedDate != null) {
                          provider.setEatingTime(DateTime(
                            selectedDate.year,
                            selectedDate.month,
                            selectedDate.day,
                            provider.eatingTime.hour,
                            provider.eatingTime.minute,
                          ));
                        }
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(children: [
                            const Icon(Icons.date_range),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(formatTimestamp2(provider.eatingTime)),
                          ]),
                          const Text("수정하기"),
                        ],
                      ),
                    ),
                    TextButton(
                      onPressed: () async {
                        final selectedTime = await showTimePicker(
                          context: context,
                          initialTime:
                              TimeOfDay.fromDateTime(provider.eatingTime),
                        );
                        if (selectedTime != null) {
                          provider.setEatingTime(DateTime(
                            provider.eatingTime.year,
                            provider.eatingTime.month,
                            provider.eatingTime.day,
                            selectedTime.hour,
                            selectedTime.minute,
                          ));
                        }
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(children: [
                            const Icon(Icons.access_time),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(formatTimestamp3(provider.eatingTime)),
                          ]),
                          const Text("수정하기"),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(children: [
                      const Text("영양 성분",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      const SizedBox(
                        width: 10,
                      ),
                      Text("섭취량 반영",
                          style: TextStyle(
                              fontSize: 14, color: Colors.grey.shade600))
                    ]),
                    const SizedBox(height: 10),
                    Column(children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const SizedBox(
                            width: 20,
                          ),
                          const Text("칼로리",
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w600)),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                              "${((double.tryParse(selectedData.NUTR_CONT1) ?? 0.0) * provider.amount).toStringAsFixed(1)}kcal",
                              style: const TextStyle(
                                fontSize: 12,
                              )),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const SizedBox(
                            width: 20,
                          ),
                          const Text("탄수화물",
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w600)),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                              "${((double.tryParse(selectedData.NUTR_CONT2) ?? 0.0) * provider.amount).toStringAsFixed(1)}g",
                              style: const TextStyle(
                                fontSize: 12,
                              )),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const SizedBox(
                            width: 20,
                          ),
                          const Text("당",
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w600)),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                              "${((double.tryParse(selectedData.NUTR_CONT5) ?? 0.0) * provider.amount).toStringAsFixed(1)}g",
                              style: const TextStyle(
                                fontSize: 12,
                              )),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const SizedBox(
                            width: 20,
                          ),
                          const Text("단백질",
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w600)),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                              "${((double.tryParse(selectedData.NUTR_CONT3) ?? 0.0) * provider.amount).toStringAsFixed(1)}g",
                              style: const TextStyle(
                                fontSize: 12,
                              )),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const SizedBox(
                            width: 20,
                          ),
                          const Text("지방",
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w600)),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                              "${((double.tryParse(selectedData.NUTR_CONT4) ?? 0.0) * provider.amount).toStringAsFixed(1)}g",
                              style: const TextStyle(
                                fontSize: 12,
                              )),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const SizedBox(
                            width: 20,
                          ),
                          const Text("나트륨",
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w600)),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                              "${((double.tryParse(selectedData.NUTR_CONT6) ?? 0.0) * provider.amount).toStringAsFixed(1)}mg",
                              style: const TextStyle(
                                fontSize: 12,
                              )),
                        ],
                      ),
                    ]),
                    const SizedBox(height: 5),
                    ButtonBar(
                      mainAxisSize: MainAxisSize.max,
                      alignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        SizedBox(
                          width: 100,
                          child: FilledButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey.shade300,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: () {
                              provider.resetData();
                            },
                            child: const Text(
                              '초기화',
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 200,
                          child: CustomButton(
                            onPressed: () {
                              if (provider.amount == 0) {
                              } else {
                                final dietProvider =
                                    context.read<DietProvider>();
                                dietProvider.notifyInsertDiet(DietCompanion(
                                  eatingTime: Value(provider.eatingTime),
                                  menuName: Value(selectedData.DESC_KOR),
                                  amount: Value(provider.amount),
                                  classification:
                                      Value(provider.classification),
                                  calories: Value((double.tryParse(
                                              selectedData.NUTR_CONT1) ??
                                          0.0) *
                                      provider.amount),
                                  carbohydrate: Value((double.tryParse(
                                              selectedData.NUTR_CONT2) ??
                                          0.0) *
                                      provider.amount),
                                  protein: Value((double.tryParse(
                                              selectedData.NUTR_CONT3) ??
                                          0.0) *
                                      provider.amount),
                                  fat: Value((double.tryParse(
                                              selectedData.NUTR_CONT4) ??
                                          0.0) *
                                      provider.amount),
                                  sodium: Value((double.tryParse(
                                              selectedData.NUTR_CONT6) ??
                                          0.0) *
                                      provider.amount),
                                  sugar: Value((double.tryParse(
                                              selectedData.NUTR_CONT5) ??
                                          0.0) *
                                      provider.amount),
                                ));
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const MyHomePage(
                                            initialIndex: 2,
                                          )),
                                  (route) => false,
                                );
                                dietProvider
                                    .setSelectedDay(provider.eatingTime);
                                dietProvider.setFocusedDay(provider.eatingTime);
                                dietProvider
                                    .notifySelectDiets(provider.eatingTime);
                              }
                            },
                            text: const Text('기록하기'),
                          ),
                        ),
                      ],
                    )
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
