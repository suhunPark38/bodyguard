import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../database/config_database.dart';
import '../../../providers/diet_provider.dart';

class DietEditDialog extends StatefulWidget {
  final DietData diet;

  const DietEditDialog({Key? key, required this.diet}) : super(key: key);

  @override
  _DietEditDialogState createState() => _DietEditDialogState();
}

class _DietEditDialogState extends State<DietEditDialog> {
  int dietId = -1;
  double calories = 0.0;
  double carbohydrates = 0.0;
  double protein = 0.0;
  double fat = 0.0;
  double sodium = 0.0;
  double sugar = 0.0;
  double amount = 0.0;
  String menuName = '';
  int classification = 0;
  DateTime eatingTime = DateTime.now();

  @override
  void initState() {
    super.initState();
    dietId = widget.diet.dietId;
    menuName = widget.diet.menuName;
    calories = widget.diet.calories;
    carbohydrates = widget.diet.carbohydrate;
    protein = widget.diet.protein;
    fat = widget.diet.fat;
    sugar = widget.diet.sugar;
    amount = widget.diet.amount;
    sodium = widget.diet.sodium;
    eatingTime = widget.diet.eatingTime;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('값을 수정하세요'),
      content: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.7,
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
            DietProvider dietProvider = context.read<DietProvider>();
            dietProvider.notifyUpdateDiet(DietCompanion(
              dietId: Value(dietId),
              eatingTime: Value(eatingTime),
              menuName: Value(menuName),
              amount: Value(amount),
              classification: Value(classification),
              calories: Value(calories * amount),
              carbohydrate: Value(carbohydrates * amount),
              protein: Value(protein * amount),
              fat: Value(fat * amount),
              sodium: Value(sodium * amount),
              sugar: Value(sugar * amount),
            ));
            Navigator.of(context).pop();
            Navigator.of(context).pop();
          },
          child: const Text('확인'),
        ),
      ],
    );
  }
}
