import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:drift/drift.dart' show Value;

import '../../../database/config_database.dart';
import '../../../model/payment.dart';
import '../../../providers/diet_provider.dart';
import '../../../providers/shopping_provider.dart';
import '../../../utils/format_util.dart';
import '../../../widgets/custom_button.dart';

class DietInputSheetFromPayment extends StatefulWidget {
  final Payment payment;
  final int checkedMenuIndex;

  const DietInputSheetFromPayment(
      {Key? key, required this.payment, required this.checkedMenuIndex})
      : super(key: key);

  @override
  _DietInputSheetFromPaymentState createState() => _DietInputSheetFromPaymentState();
}

class _DietInputSheetFromPaymentState extends State<DietInputSheetFromPayment>
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
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text(
                menuName,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ]),
            const SizedBox(
              height: 20,
            ),
            Row(children: [
              const Text("섭취량",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(
                width: 10,
              ),
              Text("1회 제공량 기준",
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade600))
            ]),
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
            const SizedBox(height: 10),
            const Row(children: [
              Text("식사 시간",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ]),
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
            const SizedBox(height: 10),
            const Row(children: [
              Text("상세 시간",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ]),
            TextButton(
              onPressed: () async {
                final selectedDate = await showDatePicker(
                  context: context,
                  initialDate: eatingTime,
                  firstDate: DateTime(2023),
                  lastDate: DateTime.now().add(const Duration(days: 365)),
                );
                if (selectedDate != null) {
                  setState(() {
                    eatingTime = DateTime(
                      selectedDate.year,
                      selectedDate.month,
                      selectedDate.day,
                      eatingTime.hour,
                      eatingTime.minute,
                    );
                  });
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
                    Text(formatTimestamp2(eatingTime)),
                  ]),
                  const Text("수정하기"),
                ],
              ),
            ),
            TextButton(
              onPressed: () async {
                final selectedTime = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.fromDateTime(eatingTime),
                );
                if (selectedTime != null) {
                  setState(() {
                    eatingTime = DateTime(
                      eatingTime.year,
                      eatingTime.month,
                      eatingTime.day,
                      selectedTime.hour,
                      selectedTime.minute,
                    );
                  });
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
                    Text(formatTimestamp3(eatingTime)),
                  ]),
                  const Text("수정하기"),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Row(children: [
              const Text("영양 성분",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(
                width: 10,
              ),
              Text("섭취량 비례",
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade600))
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
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                  const SizedBox(
                    width: 10,
                  ),
                  Text("${(calories * amount).toStringAsFixed(1)}kcal",
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
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                  const SizedBox(
                    width: 10,
                  ),
                  Text("${(carbohydrates * amount).toStringAsFixed(1)}g",
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
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                  const SizedBox(
                    width: 10,
                  ),
                  Text("${(sugar * amount).toStringAsFixed(1)}g",
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
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                  const SizedBox(
                    width: 10,
                  ),
                  Text("${(protein * amount).toStringAsFixed(1)}g",
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
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                  const SizedBox(
                    width: 10,
                  ),
                  Text("${(fat * amount).toStringAsFixed(1)}g",
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
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                  const SizedBox(
                    width: 10,
                  ),
                  Text("${(sodium * amount).toStringAsFixed(1)}mg",
                      style: const TextStyle(
                        fontSize: 12,
                      )),
                ],
              ),
            ]),
            const SizedBox(height: 10),
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
                      setState(() {
                        amount = 1;
                        classification =
                            _calculateClassification(eatingTime.hour);
                        eatingTime = widget.payment.timestamp;
                      });
                    },
                    child: const Text(
                      '초기화',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
                SizedBox(
                  width: 235,
                  child: CustomButton(
                    onPressed: () {
                      if (amount != 0) {
                        final dietProvider = context.read<DietProvider>();
                        dietProvider.notifyInsertDiet(DietCompanion(
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
                      } else {
                        _shakeController.forward(from: 0.0);
                        _shakeController.repeat(reverse: true);
                        Timer(const Duration(milliseconds: 500), () {
                          _shakeController.stop();
                        });
                      }
                    },
                    text: const Text('기록하기'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
