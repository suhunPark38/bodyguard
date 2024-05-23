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

class DietInputDialogContent extends StatefulWidget {
  final FetchedDietData selectedData;

  DietInputDialogContent({required this.selectedData});

  @override
  _DietInputDialogContentState createState() => _DietInputDialogContentState();
}

class _DietInputDialogContentState extends State<DietInputDialogContent>
    with SingleTickerProviderStateMixin {
  late AnimationController _shakeController;
  late Animation<double> _shakeAnimation;


  @override
  void initState() {
    super.initState();
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
                      AnimatedBuilder(
                        animation: _shakeController,
                        builder: (context, child) {
                          return Transform.translate(
                            offset: Offset(_shakeAnimation.value, 0),
                            child: child,
                          );
                        },
                        child: provider.amount == 0
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
                            lastDate: DateTime.now().add(const Duration(days: 365)),
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
                            const Text('식사 시간'),
                            const SizedBox(height: 10),
                            Text(DateFormat('yyyy년 MM월 dd일 HH시 mm분')
                                .format(provider.eatingTime)),
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
                        selected: <int>{provider.classification},
                        onSelectionChanged: (selected) {
                          provider.setClassification(selected.first);
                        },
                      ),
                      const SizedBox(height: 10),

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
            return FilledButton(
              onPressed: () {
                if (provider.amount == 0) {
                  setState(() {
                  });
                  _shakeController.forward(from: 0.0);
                  _shakeController.repeat(reverse: true);
                  Future.delayed(const Duration(milliseconds: 500), () {
                    _shakeController.stop();
                  });
                } else {
                  final dietProvider = context.read<DietProvider>();
                  dietProvider.notifyInsertDiet(DietCompanion(
                    eatingTime: Value(provider.eatingTime),
                    menuName: Value(widget.selectedData.DESC_KOR),
                    amount: Value(provider.amount),
                    classification: Value(provider.classification),
                    calories: Value(
                        (double.tryParse(widget.selectedData.NUTR_CONT1) ?? 0.0) *
                            provider.amount),
                    carbohydrate: Value(
                        (double.tryParse(widget.selectedData.NUTR_CONT2) ?? 0.0) *
                            provider.amount),
                    protein: Value(
                        (double.tryParse(widget.selectedData.NUTR_CONT3) ?? 0.0) *
                            provider.amount),
                    fat: Value(
                        (double.tryParse(widget.selectedData.NUTR_CONT4) ?? 0.0) *
                            provider.amount),
                    sodium: Value(
                        (double.tryParse(widget.selectedData.NUTR_CONT6) ?? 0.0) *
                            provider.amount),
                    sugar: Value(
                        (double.tryParse(widget.selectedData.NUTR_CONT5) ?? 0.0) *
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
