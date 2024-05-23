import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:drift/drift.dart' show Value;

import '../../../database/config_database.dart';
import '../../../model/payment.dart';
import '../../../providers/diet_provider.dart';
import '../../../providers/shopping_provider.dart';
import '../../../utils/format_util.dart';

class DietInputDialogFromPayment extends StatefulWidget {
  final Payment payment;
  final int checkedMenuIndex;

  const DietInputDialogFromPayment(
      {Key? key, required this.payment, required this.checkedMenuIndex})
      : super(key: key);

  @override
  _DietInputDialogState createState() => _DietInputDialogState();
}

class _DietInputDialogState extends State<DietInputDialogFromPayment>
    with SingleTickerProviderStateMixin {
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

  late AnimationController _shakeController;
  late Animation<double> _shakeAnimation;

  @override
  void initState() {
    super.initState();

    var shoppingProvider =
    Provider.of<ShoppingProvider>(context, listen: false);
    var checkedMenu = shoppingProvider.checkedMenus[widget.checkedMenuIndex];
    menuName = checkedMenu.menuName;
    calories = checkedMenu.calories;
    carbohydrates = checkedMenu.carbohydrate;
    protein = checkedMenu.protein;
    fat = checkedMenu.fat;
    sodium = checkedMenu.sodium;
    sugar = checkedMenu.sugar;
    eatingTime = widget.payment.timestamp;

    classification = _calculateClassification(eatingTime.hour);

    amount = 1;

    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 50),
      vsync: this,
    );

    _shakeAnimation = Tween<double>(begin: -5.0, end: 5.0).animate(
      CurvedAnimation(parent: _shakeController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _shakeController.dispose();
    super.dispose();
  }

  int _calculateClassification(int hour) {
    if (hour >= 6 && hour < 12) {
      return 0;
    } else if (hour >= 12 && hour < 17) {
      return 1;
    } else {
      return 2;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(menuName),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const Text("섭취량(1회 제공량 기준)"),

            const SizedBox(height: 10),
            Text(
              amount.toStringAsFixed(1),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            AnimatedBuilder(
              animation: _shakeController,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(_shakeAnimation.value, 0),
                  child: child,
                );
              },
              child: amount == 0
                  ? const Text(
                "섭취량은 0보다 커야해요.",
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.w500,
                ),
              )
                  : const SizedBox(), // 또는 다른 위젯으로 대체 가능합니다.

            ),

            Slider(
              value: amount,
              min: 0.0,
              max: 10.0,
              divisions: 100,
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
                    const Text('식사 시간'),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(formatTimestamp(eatingTime)),
                  ],
                ),
              ),


            const SizedBox(height: 10),
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
            ),
          ],
        ),
      ),
      actions: <Widget>[
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('취소'),
        ),
        FilledButton(
          onPressed: () {
            if (amount != 0) {
              final dietProvider = context.read<DietProvider>();
              dietProvider.notifyInsertDiet(DietCompanion(
                eatingTime: Value(eatingTime),
                menuName: Value(menuName),
                amount: Value(amount),
                classification: Value(classification),
                calories: Value(calories),
                carbohydrate: Value(carbohydrates),
                protein: Value(protein),
                fat: Value(fat),
                sodium: Value(sodium),
                sugar: Value(sugar),
              ));
              Navigator.of(context).pop();
            } else {
              _shakeController.forward(from: 0.0);
              _shakeController.repeat(reverse: true);
              Timer(const Duration(milliseconds: 500), () {
                _shakeController.stop();
              });
            }
          },
          child: const Text('확인'),
        ),
      ],
    );
  }
}
