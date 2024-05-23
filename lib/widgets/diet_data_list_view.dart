import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/fetched_diet_data.dart';
import '../providers/diet_data_provider.dart';
import '../screens/diet_search_page/widgets/diet_input_dialog.dart';

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
                  icon: const Icon(Icons.info),
                  onPressed: () {
                    _showDietDetail(context, fetchedData);
                  },
                ),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () =>
                    showDialog(
                      context: context,
                      builder: (context) =>
                          DietInputDialog(selectedData: fetchedData),
                    ),
              );
            },
          );
        }
      },
    );
  }

  void _showDietDetail(BuildContext context, FetchedDietData selectedData) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)), // 다이얼로그 모서리 둥글게
        title: Text(
          selectedData.DESC_KOR,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20, // 폰트 크기 조정
             // 제목 폰트 색상 변경
          ),
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.business, ), // 업체 아이콘 추가
                  SizedBox(width: 10), // 아이콘과 텍스트 사이 간격 조정
                  Expanded(
                    child: Text(
                      '업체명: ${selectedData.MAKER_NAME}',
                      style: TextStyle(fontSize: 16, ), // 본문 폰트 크기 및 색상 조정
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Divider(), // 구분선 추가
              SizedBox(height: 10),
              _buildNutritionInfo(
                  icon: Icons.local_fire_department,
                  iconColor: Colors.black,
                  title: '칼로리',
                  value: '${selectedData.NUTR_CONT1} kcal',
                  textColor: Colors.black
              ),
              _buildNutritionInfo(
                image: AssetImage("assets/nutrition_icon/carbohydrates.png"),
                iconColor: Colors.black,
                title: '탄수화물',
                value: '${selectedData.NUTR_CONT2}g',
                textColor: Colors.black,
              ),
              _buildNutritionInfo(
                image: AssetImage("assets/nutrition_icon/protein.png"),
                iconColor: Colors.black,
                title: '단백질',
                value: '${selectedData.NUTR_CONT3}g',
                textColor: Colors.black,
              ),
              _buildNutritionInfo(
                icon: Icons.fastfood,
                iconColor: Colors.black,
                title: '지방',
                value: '${selectedData.NUTR_CONT4}g',
                textColor: Colors.black,
              ),
              _buildNutritionInfo(
                image: AssetImage("assets/nutrition_icon/sugar.png"),
                iconColor: Colors.black,
                title: '당류',
                value: '${selectedData.NUTR_CONT5}g',
                textColor: Colors.black,
              ),
              _buildNutritionInfo(
                image: AssetImage("assets/nutrition_icon/salt.png"),
                iconColor: Colors.black,
                title: '나트륨',
                value: '${selectedData.NUTR_CONT6}mg',
                textColor: Colors.black,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              "닫기",
              style: TextStyle(
                color: Colors.black, // 버튼 텍스트 색상 변경
                fontWeight: FontWeight.bold, // 버튼 텍스트 굵기 조정
              ),
            ),
          ),
        ],
        backgroundColor: Colors.white, // 다이얼로그 배경색 변경 (필요에 따라 조정)
      ),
    );
  }

  Widget _buildNutritionInfo({IconData? icon, AssetImage? image, required Color iconColor, required String title, required String value, required Color textColor}) {
    return ListTile(
      leading: icon != null
          ? Icon(icon, color: iconColor)
          : ImageIcon(image, size: 28.0, color: iconColor), // 아이콘 또는 이미지 아이콘 사용
      title: Text(
        title,
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: iconColor),
      ),
      subtitle: Text(
        value,
        style: TextStyle(fontSize: 14, color: textColor),
      ),
    );
  }

}