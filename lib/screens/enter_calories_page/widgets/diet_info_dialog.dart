import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../database/config_database.dart';
import 'delete_diet_dialog.dart';

class DietInfoDialog extends StatelessWidget {
  final BuildContext parentContext;
  final DietData diet;

  const DietInfoDialog({required this.parentContext, required this.diet});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('식단 정보'),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () => showDialog(
                    context: parentContext,
                    builder: (context) => DeleteDietDialog(context: context, dietData: diet)
                ),

              ),
            ],
          )
        ],
      ),
      content: SingleChildScrollView(
        child: DataTable(
          columns: [
            DataColumn(label: Text('정보')),
            DataColumn(label: Text('내용')),
          ],
          rows: [
            DataRow(cells: [
              DataCell(Text('메뉴이름')),
              DataCell(Text(diet.menuName)),
            ]),
            DataRow(cells: [
              DataCell(Text('먹은시간')),
              DataCell(Text(DateFormat('yyyy년 MM월 dd일 HH시 mm분')
                  .format(diet.eatingTime))),
            ]),
            DataRow(cells: [
              DataCell(Text('먹은 양')),
              DataCell(Text(diet.amount.toString())),
            ]),
            DataRow(cells: [
              DataCell(Text('칼로리')),
              DataCell(Text('${diet.calories}kcal')),
            ]),
            DataRow(cells: [
              DataCell(Text('탄수화물')),
              DataCell(Text('${diet.carbohydrate}g')),
            ]),
            DataRow(cells: [
              DataCell(Text('단백질')),
              DataCell(Text('${diet.protein}g')),
            ]),
            DataRow(cells: [
              DataCell(Text('지방')),
              DataCell(Text('${diet.fat}g')),
            ]),
            DataRow(cells: [
              DataCell(Text('나트륨')),
              DataCell(Text('${diet.sodium}mg')),
            ]),
            DataRow(cells: [
              DataCell(Text('당류')),
              DataCell(Text('${diet.sugar}g')),
            ]),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('닫기'),
        ),
        IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () => showDialog(
              context: parentContext,
              builder: (context) => DeleteDietDialog(context: context, dietData: diet)
          ),
        ),
      ],
    );
  }
}
