import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../database/config_database.dart';
import '../../../providers/diet_data_provider.dart';
import '../../../widgets/custom_button.dart';
import 'diet_delete_dialog.dart';
import 'diet_edit_sheet.dart';

class DietInfoSheet extends StatelessWidget {
  final BuildContext parentContext;
  final DietData diet;

  const DietInfoSheet(
      {super.key, required this.parentContext, required this.diet});

  static void show(BuildContext context, DietData diet) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      isScrollControlled: true,
      builder: (context) => DietInfoSheet(parentContext: context, diet: diet),
    );
  }

  String _getClassificationText(int classification) {
    switch (classification) {
      case 0:
        return '아침';
      case 1:
        return '점심';
      case 2:
        return '저녁';
      default:
        return '기타';
    }
  }

  Color _getClassificationColor(int classification) {
    switch (classification) {
      case 0: // 아침
        return Colors.orange;
      case 1: // 점심
        return Colors.green;
      case 2: // 저녁
        return Colors.blue;
      default: // 기타
        return Colors.black; // 기타 경우의 색상을 여기에 지정할 수 있습니다.
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
              Row(
                children: [
                  Text(
                    diet.menuName,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Text(
                        _getClassificationText(diet.classification),
                        style: TextStyle(
                            fontSize: 14,
                            color:
                                _getClassificationColor(diet.classification)),
                      ),
                    ),
                  )
                ],
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ]),
            const SizedBox(
              height: 10,
            ),
            DataTable(
              columns: const [
                DataColumn(label: Text('정보')),
                DataColumn(label: Text('내용')),
              ],
              rows: [
                DataRow(cells: [
                  const DataCell(Text('먹은 시간')),
                  DataCell(Text(DateFormat('yyyy년 MM월 dd일 HH시 mm분')
                      .format(diet.eatingTime))),
                ]),
                DataRow(cells: [
                  const DataCell(Text('섭취량')),
                  DataCell(Text(diet.amount.toStringAsFixed(1))),
                ]),
                DataRow(cells: [
                  const DataCell(Text('칼로리')),
                  DataCell(Text('${(diet.calories).toStringAsFixed(1)}kcal')),
                ]),
                DataRow(cells: [
                  const DataCell(Text('탄수화물')),
                  DataCell(Text('${diet.carbohydrate.toStringAsFixed(1)}g')),
                ]),
                DataRow(cells: [
                  const DataCell(Text('당류')),
                  DataCell(Text('${diet.sugar.toStringAsFixed(1)}g')),
                ]),
                DataRow(cells: [
                  const DataCell(Text('단백질')),
                  DataCell(Text('${diet.protein.toStringAsFixed(1)}g')),
                ]),
                DataRow(cells: [
                  const DataCell(Text('지방')),
                  DataCell(Text('${diet.fat.toStringAsFixed(1)}g')),
                ]),
                DataRow(cells: [
                  const DataCell(Text('나트륨')),
                  DataCell(Text('${diet.sodium.toStringAsFixed(1)}mg')),
                ]),
              ],
            ),
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
                      Navigator.pop(context);
                      showDialog(
                        context: parentContext,
                        builder: (context) =>
                            DietDeleteDialog(context: context, dietData: diet),
                      );
                    },
                    child: const Text(
                      '삭제하기',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ),
                SizedBox(
                  width: 235,
                  child: CustomButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Provider.of<DietDataProvider>(context, listen: false).setAmount(diet.amount);
                      Provider.of<DietDataProvider>(context, listen: false).setClassification(diet.classification);
                      Provider.of<DietDataProvider>(context, listen: false).setEatingTime(diet.eatingTime);
                      DietEditSheet.show(context, diet);
                    },
                    text: const Text('수정하기'),
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
