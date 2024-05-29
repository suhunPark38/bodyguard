import 'package:bodyguard/providers/health_data_provider.dart';
import 'package:bodyguard/providers/user_info_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/diet_provider.dart';
import '../../utils/format_util.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/nutrition_info.dart';
import 'widgets/diets_card.dart';
import 'widgets/diet_calendar.dart';

class DietPage extends StatelessWidget {
  const DietPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<DietProvider>(
      builder: (context, provider, child) {
        final DateTime now = DateTime.utc(
            DateTime.now().year, DateTime.now().month, DateTime.now().day);

        final double caloriesPercentage =
            provider.calculateCaloriesPercentage();
        final bool isOverRecommended = provider.totalNutritionalInfo.calories >
            provider.recommendedCalories;
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const DietCalendar(),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          '${provider.selectedDay.day}',
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(width: 8),
                        Text('${getWeekday(provider.selectedDay)}요일'),
                      ],
                    ),
                    SizedBox(
                      width: 90,
                      height: 20,
                      child: CustomButton(
                        onPressed: () {
                          provider.setSelectedDay(now);
                          provider.notifySelectDiets(provider.selectedDay);
                          provider.setFocusedDay(now);
                        },
                        text: const Text(
                          "오늘 날짜로",
                          style: TextStyle(fontSize: 9),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "총 칼로리/(권장)",
                                style: TextStyle(
                                    color: Colors.blueGrey, fontSize: 15),
                              ),
                              Icon(Icons.fastfood)
                            ]),
                        const SizedBox(height: 10),
                        Consumer2<UserInfoProvider, HealthDataProvider>(
                            builder: (context, user, health, child){
                              var BMR = (10 * health.weight) + (6.25 * health.height) - 5 * (user.info?.age ?? 25);
                              print("BMR는 $BMR 성별은 ${user.info!.gender}");
                              user.info?.gender == "남" ? BMR += 5 : BMR -= 161;
                              provider.recommendedCalories = BMR * 1.55;
                              return Text(
                                '${provider.totalNutritionalInfo.calories.toStringAsFixed(2)} / ${provider.recommendedCalories.toStringAsFixed(2)}kcal',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              );
                            }
                        ),

                        const SizedBox(height: 10),
                        LinearProgressIndicator(
                          value: caloriesPercentage,
                          backgroundColor: Colors.grey.shade300,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            isOverRecommended ? Colors.pink : Colors.teal,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '0',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              '${provider.recommendedCalories.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.25,
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      DietsCard(
                        classification: 0,
                        cardColor: Colors.orange,
                      ),
                      DietsCard(
                        classification: 1,
                        cardColor: Colors.green,
                      ),
                      DietsCard(
                        classification: 2,
                        cardColor: Colors.blue,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "영양소",
                                      style: TextStyle(
                                          color: Colors.blueGrey, fontSize: 15),
                                    ),
                                    Icon(Icons.analytics)
                                  ]),
                              SizedBox(height: 25),
                              NutritionInfo(),
                            ])))
              ],
            ),
          ),
        );
      },
    );
  }
}
