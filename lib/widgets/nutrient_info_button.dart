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
              title: Text('${menu.menuName} - 영양성분'),
              content: Text('칼로리: ${menu.calories},'
                  ' 탄수화물: ${menu.carbohydrate},'
                  ' 단백질: ${menu.protein},'
                  ' 지방: ${menu.fat},'
                  ' 나트륨: ${menu.sodium},'
                  ' 당: ${menu.sugar}'),
            );
          },
        );
      },
    );
  }
}
