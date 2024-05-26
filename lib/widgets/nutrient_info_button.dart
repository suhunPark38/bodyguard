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
        showModalBottomSheet(
          context: context,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
          ),
          isScrollControlled: true,
          builder: (context) {
            return SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          menu.menuName,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Icon(Icons.business),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            menu.storeName,
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    const Divider(),
                    _buildNutritionInfo(
                      icon: Icons.local_fire_department,
                      title: '칼로리',
                      value: '${menu.calories}kcal',
                    ),
                    _buildNutritionInfo(
                      image: const AssetImage(
                          "assets/nutrition_icon/carbohydrates.png"),
                      title: '탄수화물',
                      value: '${menu.carbohydrate}g',
                    ),
                    _buildNutritionInfo(
                      image: const AssetImage("assets/nutrition_icon/sugar.png"),
                      title: '당류',
                      value: '${menu.sugar}g',
                    ),
                    _buildNutritionInfo(
                      image: const AssetImage("assets/nutrition_icon/protein.png"),
                      title: '단백질',
                      value: '${menu.protein}g',
                    ),
                    _buildNutritionInfo(
                      icon: Icons.fastfood,
                      title: '지방',
                      value: '${menu.fat}g',
                    ),
                    _buildNutritionInfo(
                      image: const AssetImage("assets/nutrition_icon/salt.png"),
                      title: '나트륨',
                      value: '${menu.sodium}mg',
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

  Widget _buildNutritionInfo({
    IconData? icon,
    AssetImage? image,
    required String title,
    required String value,
  }) {
    return ListTile(
      leading: icon != null ? Icon(icon) : ImageIcon(image, size: 25.0),
      // 아이콘 또는 이미지 아이콘 사용
      title: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        value,
        style: const TextStyle(fontSize: 14),
      ),
    );
  }
}
