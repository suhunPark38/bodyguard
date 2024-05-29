import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../database/local_database.dart';
import '../../../providers/diet_provider.dart';
import '../../../utils/calculate_util.dart';
import 'diet_info_sheet.dart';

class DietsCard extends StatelessWidget {
  final int classification;
  final Color cardColor;

  const DietsCard({
    Key? key,
    required this.classification,
    this.cardColor = Colors.white,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DietProvider dietProvider = context.watch<DietProvider>();
    String title = '';
    List<DietData> diets = [];
    switch (classification) {
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
        color: cardColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 5,
        child: Column(
          children: [
            InkWell(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                physics: const ClampingScrollPhysics(),
                shrinkWrap: true,
                itemCount: diets.length,
                itemBuilder: (context, index) {
                  DietData diet = diets[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 1.0),
                    child: Container(
                      height: 30,
                      decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.white, width: 1),
                      ),
                      child: InkWell(
                        onTap: () => DietInfoSheet.show(
                          context,
                          diet,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Expanded(
                                child: Text(
                                  diet.menuName,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.white,
                                  ),
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ),
                              const Icon(Icons.arrow_forward_ios,
                                  size: 12, color: Colors.white),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Text(
              '${CalculateUtil().getSumOfLists(
                    diets.map((diet) => diet.calories).toList(),
                  ).toStringAsFixed(1)} kcal',
              style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
