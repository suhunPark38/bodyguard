import 'package:bodyguard/database/config_database.dart';
import 'package:bodyguard/screens/enter_calories_page/widgets/diet_info_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/diet_provider.dart';
import '../../../utils/calculate_util.dart';

class DietsCard extends StatefulWidget {
  final int classification;

  const DietsCard({Key? key, required this.classification}) : super(key: key);

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
    String title = '';
    List<DietData> diets = [];

    switch(widget.classification){
      case 0:
        title = '아침';
        diets = dietProvider.breakfast;
        break;
      case 1:
        title = '점심';
        diets = dietProvider.lunch;
        break;
      case 2:
        title = '저녁';
        diets = dietProvider.dinner;
        break;
    }

    return Expanded(
      child: Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 5,
        child: Column(
          children: [
            InkWell(
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
                      height: 200,
                      child: ListView.builder(
                        physics: const ClampingScrollPhysics(),
                        shrinkWrap: true, // ListView 높이 제한
                        itemCount: diets.length,
                        itemBuilder: (context, index) {
                          DietData diet = diets[index];
                          return SizedBox(
                            height: 80,
                            child: Column(
                              children: [
                                ListTile(
                                  contentPadding: EdgeInsets.zero, // ListTile 내용의 패딩 제거
                                  title: Text(
                                    diet.menuName,
                                    textAlign: TextAlign.center, // 제목 가운데 정렬
                                    overflow: TextOverflow.ellipsis, // 텍스트가 넘치면 생략 (...) 표시
                                    maxLines: 1, // 한 줄로 표시
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
                            ),
                          );
                        },
                      ),
                    ),

                  ],
                ),
              ),
            ),
            Container(
              alignment: Alignment.bottomCenter,
              padding: EdgeInsets.only(bottom: 5),
              child: Text(
                '총 칼로리: \n ${CalculateUtil().getSumOfLists(diets.map((diet) => diet.calories).toList())}kcal',
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        )


      ),
    );
  }
}
