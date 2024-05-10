import 'package:bodyguard/model/fetched_diet_data.dart';
import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../database/config_database.dart';
import '../../../model/payment.dart';
import '../../../providers/diet_provider.dart';

class DietInputDialog2 extends StatefulWidget {

  final Payment payment;

  const DietInputDialog2({Key? key, required this.payment}) : super(key: key);

  @override
  _DietInputDialogState createState() => _DietInputDialogState();
}

class _DietInputDialogState extends State<DietInputDialog2> {
  double calories = 0;
  double carbohydrates = 0;
  double protein = 0;
  double fat = 0;
  double sodium = 0;
  double sugar = 0;
  double amount = 0.0;
  String menuName = '';
  int classification = 0;
  late DateTime eatingTime;

  @override
  void initState() {
    super.initState();

    menuName = widget.payment.menuItems.first.menu.menuName;
    calories = widget.payment.menuItems.first.menu.calories;
    carbohydrates = widget.payment.menuItems.first.menu.carbohydrate;
    protein = widget.payment.menuItems.first.menu.protein;
    fat = widget.payment.menuItems.first.menu.fat;
    sodium = widget.payment.menuItems.first.menu.sodium;
    sugar=widget.payment.menuItems.first.menu.sugar;
    eatingTime = widget.payment.timestamp;

  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('값을 입력하세요'),
      content: SingleChildScrollView(
        child: SizedBox(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const Text("먹은 양을 입력하세요 (1회 제공량 기준)"),
              Text(
                amount.toStringAsFixed(1),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Slider(
                value: amount,
                min: 0.0,
                max: 3.0,
                divisions: 6,
                label: amount.toStringAsFixed(1),
                onChanged: (double newValue) {
                  setState(() {
                    amount = newValue;
                  });
                },
              ),
              TextButton(
                onPressed: () async {
                  final selectedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2023),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (selectedDate != null) {
                    final selectedTime = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.fromDateTime(selectedDate),
                    );
                    if (selectedTime != null) {
                      setState(() {
                        eatingTime = DateTime(
                          selectedDate.year,
                          selectedDate.month,
                          selectedDate.day,
                          selectedTime.hour,
                          selectedTime.minute,
                        );
                      });
                    }
                  }
                },
                child: Column(
                  children: <Widget>[
                    const Text(
                      '먹은 시간 입력: ',
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                        DateFormat('yyyy년 MM월 dd일 HH시 mm분').format(eatingTime)),
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
                selected: <int>{classification},
                onSelectionChanged: (selected) {
                  setState(() {
                    classification = selected.first;
                  });
                },
              )
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
        ElevatedButton(
          onPressed: () {
            if (amount == 0) {
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
                eatingTime: Value(eatingTime),
                menuName: Value(menuName),
                amount: Value(amount),
                classification: Value(classification),
                calories: Value(calories),
                carbohydrate:
                    Value(carbohydrates),
                protein: Value(protein),
                fat: Value(fat),
                sodium: Value(sodium),
                sugar: Value(sugar),
              ));
            }
          },
          child: const Text('확인'),
        ),
      ],
    );
  }
}
