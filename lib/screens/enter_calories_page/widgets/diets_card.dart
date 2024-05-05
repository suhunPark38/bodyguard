import 'package:bodyguard/database/config_database.dart';
import 'package:bodyguard/screens/enter_calories_page/widgets/diet_info_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/diet_provider.dart';
import '../../../utils/diet_util.dart';
import '../../../utils/calculate_util.dart';

class DietsCard extends StatefulWidget {
  final String title;

  const DietsCard({Key? key, required this.title}) : super(key: key);

  @override
  _DietsCardState createState() => _DietsCardState();
}

class _DietsCardState extends State<DietsCard> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    DietProvider dietProvider = context.watch<DietProvider>();

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
                  widget.title,
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
                    itemCount: dietProvider.diets.length,
                    itemBuilder: (context, index) {
                      final diet = dietProvider.diets[index];
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
                            onTap: () => showDialog(
                              context: context,
                              builder: (context) => DietInfoDialog(parentContext: context, diet: diet)
                            ),
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
                    '총 칼로리: ${CalculateUtil().getSumOfLists(dietProvider.diets.map((diet) => diet.calories).toList())}kcal',
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
