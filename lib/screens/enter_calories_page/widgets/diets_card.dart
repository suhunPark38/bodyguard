import 'package:bodyguard/database/configDatabase.dart';
import 'package:flutter/material.dart';

import '../../../utils/DietUtil.dart';
import '../../../utils/calculateUtil.dart';

class DietsCard extends StatelessWidget {
  final String title;
  final List<DietData> diets;

  const DietsCard({Key? key, required this.title, required this.diets})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 5,
        child: InkWell(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.25,
                  child: ListView.builder(
                    shrinkWrap: true, // ListView 높이 제한
                    itemCount: diets.length,
                    itemBuilder: (context, index) {
                      final diet = diets[index];
                      return Column(
                        children: [
                          ListTile(
                            // ListTile 사용하여 메뉴 이름 표시
                            title: Text(
                              diet.menuName,
                              textAlign: TextAlign.center, // 제목 가운데 정렬
                            ),
                            tileColor: Colors.white60,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            onTap: () => DietUtil()
                                .showDietDetails(context, diet), // Replace with your logic
                          ),
                          const Divider(), // 각 메뉴 구분선 추가
                        ],
                      );
                    },
                  ),
                ),
                Positioned(
                  bottom: 5,
                  child: Text(
                    '총 칼로리: ${CalculateUtil().getSumOfLists(diets.map((diet) => diet.calories).toList())}kcal',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
