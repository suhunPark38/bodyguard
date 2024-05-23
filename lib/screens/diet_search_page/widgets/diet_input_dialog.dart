import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bodyguard/model/fetched_diet_data.dart';
import 'package:bodyguard/providers/diet_data_provider.dart';
import 'package:bodyguard/providers/diet_provider.dart';
import 'package:bodyguard/database/config_database.dart';
import 'package:intl/intl.dart';

import '../../my_home_page/my_home_page.dart';

class DietInputDialog extends StatelessWidget {
  final FetchedDietData selectedData;

  const DietInputDialog({Key? key, required this.selectedData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DietDataProvider(),
      child: DietInputDialogContent(selectedData: selectedData),
    );
  }
}

class DietInputDialogContent extends StatelessWidget {
  final FetchedDietData selectedData;

  DietInputDialogContent({required this.selectedData});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('식단 입력'),
      content: SingleChildScrollView(
        child: SizedBox(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const Text("섭취량(1회 제공량 기준)"),
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
                      TextButton(
                        onPressed: () async {
                          final selectedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2023),
                            lastDate:
                            DateTime.now().add(const Duration(days: 365)),
                          );
                          if (selectedDate != null) {
                            final selectedTime = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.fromDateTime(selectedDate),
                            );
                            if (selectedTime != null) {
                              provider.setEatingTime(DateTime(
                                selectedDate.year,
                                selectedDate.month,
                                selectedDate.day,
                                selectedTime.hour,
                                selectedTime.minute,
                              ));
                            }
                          }
                        },
                        child: Column(
                          children: <Widget>[
                            const Text(
                              '식사 시간',
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(DateFormat('yyyy년 MM월 dd일 HH시 mm분')
                                .format(provider.eatingTime)),
                          ],
                        ),
                      ),
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
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('취소'),
        ),
        Consumer<DietDataProvider>(
          builder: (context, provider, child) {
            return ElevatedButton(
              onPressed: () {
                if (provider.amount == 0) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('경고'),
                        content: const Text('먹은 양을 0 보다 크게 입력하세요'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('확인'),
                          ),
                        ],
                      );
                    },
                  );
                } else {
                  final dietProvider = context.read<DietProvider>();
                  dietProvider.notifyInsertDiet(DietCompanion(
                    eatingTime: Value(provider.eatingTime),
                    menuName: Value(selectedData.DESC_KOR),
                    amount: Value(provider.amount),
                    classification: Value(provider.classification),
                    calories: Value(
                        (double.tryParse(selectedData.NUTR_CONT1) ?? 0.0) *
                            provider.amount),
                    carbohydrate: Value(
                        (double.tryParse(selectedData.NUTR_CONT2) ?? 0.0) *
                            provider.amount),
                    protein: Value(
                        (double.tryParse(selectedData.NUTR_CONT3) ?? 0.0) *
                            provider.amount),
                    fat: Value(
                        (double.tryParse(selectedData.NUTR_CONT4) ?? 0.0) *
                            provider.amount),
                    sodium: Value(
                        (double.tryParse(selectedData.NUTR_CONT6) ?? 0.0) *
                            provider.amount),
                    sugar: Value(
                        (double.tryParse(selectedData.NUTR_CONT5) ?? 0.0) *
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
                }
              },
              child: const Text('확인'),
            );
          },
        ),
      ],
    );
  }
}
