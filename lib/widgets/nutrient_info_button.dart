import 'package:flutter/material.dart';
import '../model/store_menu.dart';

class NutrientInfoButton extends StatelessWidget {
  const NutrientInfoButton({
    Key? key,
    required this.size,
    required this.menu,
  }) : super(key: key);

  final double size;
  final StoreMenu menu;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.info),
      iconSize: size,
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('영양성분표'
                  '\n(${menu.menuName})'),
              content: SingleChildScrollView(
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text('영양소')),
                    DataColumn(label: Text('함량')),
                  ],
                  rows: [
                    DataRow(
                      cells: [
                        const DataCell(Text('칼로리')),
                        DataCell(Text('${menu.calories}kcal')),
                      ],
                    ),
                    DataRow(cells: [
                      const DataCell(
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('탄수화물'),
                            Text('당'),
                          ],
                        ),
                      ),
                      DataCell(Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('${menu.carbohydrate}g'),
                            Text('${menu.sugar}g'),
                          ])),
                    ]),
                    DataRow(
                      cells: [
                        const DataCell(Text('단백질')),
                        DataCell(Text('${menu.protein}g')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        const DataCell(Text('지방')),
                        DataCell(Text('${menu.fat}g')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        const DataCell(Text('나트륨')),
                        DataCell(Text('${menu.sodium}mg')),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
