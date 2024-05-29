import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/fetched_diet_data.dart';
import '../providers/diet_data_provider.dart';
import 'diet_input_sheet.dart';

class DietDataListView extends StatelessWidget {
  const DietDataListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DietDataProvider>(
      builder: (context, provider, _) {
        if (provider.dietDataList.isEmpty) {
          return const Center(child: Text("해당하는 음식이 없어요."));
        } else {
          return ListView.builder(
            itemCount: provider.dietDataList.length,
            itemBuilder: (context, index) {
              final fetchedData = provider.dietDataList[index];
              return ListTile(
                title: Text(fetchedData.DESC_KOR),
                subtitle: Text("${fetchedData.NUTR_CONT1}kcal"),
                leading: IconButton(
                  icon: const Icon(
                    Icons.info,
                    size: 20,
                  ),
                  onPressed: () {
                    _showDietDetail(context, fetchedData);
                  },
                ),
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  size: 20,
                ),
                onTap: () => DietInputSheet.show(context, fetchedData),
              );
            },
          );
        }
      },
    );
  }

  void _showDietDetail(BuildContext context, FetchedDietData selectedData) {
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
                    Expanded(
                      child: Text(
                        selectedData.DESC_KOR,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          overflow: TextOverflow.ellipsis,
                        ),
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
                        selectedData.MAKER_NAME,
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
                  value: '${selectedData.NUTR_CONT1}kcal',
                ),
                _buildNutritionInfo(
                  image: const AssetImage(
                      "assets/nutrition_icon/carbohydrates.png"),
                  title: '탄수화물',
                  value: '${selectedData.NUTR_CONT2}g',
                ),
                _buildNutritionInfo(
                  image: const AssetImage("assets/nutrition_icon/sugar.png"),
                  title: '당류',
                  value: '${selectedData.NUTR_CONT5}g',
                ),
                _buildNutritionInfo(
                  image: const AssetImage("assets/nutrition_icon/protein.png"),
                  title: '단백질',
                  value: '${selectedData.NUTR_CONT3}g',
                ),
                _buildNutritionInfo(
                  icon: Icons.fastfood,
                  title: '지방',
                  value: '${selectedData.NUTR_CONT4}g',
                ),
                _buildNutritionInfo(
                  image: const AssetImage("assets/nutrition_icon/salt.png"),
                  title: '나트륨',
                  value: '${selectedData.NUTR_CONT6}mg',
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildNutritionInfo(
      {IconData? icon,
      AssetImage? image,
      required String title,
      required String value}) {
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
