import 'package:bodyguard/providers/health_data_provider.dart';
import 'package:bodyguard/providers/user_info_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/diet_provider.dart';
import '../../utils/format_util.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/nutrition_info.dart';
import '../diet_search_page/diet_search_page.dart';
import 'widgets/diets_card.dart';
import 'widgets/diet_calendar.dart';

class DietPage extends StatelessWidget {
  const DietPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    return Consumer<DietProvider>(
      builder: (context, provider, child) {
        final DateTime now = DateTime.utc(
            DateTime.now().year, DateTime.now().month, DateTime.now().day);

        final double caloriesPercentage =
            provider.calculateCaloriesPercentage();
        final bool isOverRecommended = provider.totalNutritionalInfo.calories >
            provider.recommendedCalories;

        return RefreshIndicator(
            onRefresh: () async {
              provider.setSelectedDay(now);
              provider.notifySelectDiets(provider.selectedDay);
              provider.setFocusedDay(now);
              Provider.of<HealthDataProvider>(context, listen: false)
                  .selectedDate = provider.selectedDay;
              Provider.of<HealthDataProvider>(context, listen: false)
                  .fetchData(provider.selectedDay);
            },
            child: SingleChildScrollView(
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
                          width: screenWidth * 0.3,
                          height: screenHeight * 0.025,
                          child: CustomButton(
                            onPressed: () {
                              provider.setSelectedDay(now);
                              provider.notifySelectDiets(provider.selectedDay);
                              provider.setFocusedDay(now);
                              Provider.of<HealthDataProvider>(context,
                                      listen: false)
                                  .fetchData(provider.selectedDay);
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
                                    "섭취 칼로리 / 권장 칼로리",
                                    style: TextStyle(
                                        color: Colors.blueGrey, fontSize: 15),
                                  ),
                                  Icon(Icons.fastfood)
                                ]),
                            const SizedBox(height: 10),
                            Consumer2<UserInfoProvider, HealthDataProvider>(
                                builder: (context, user, health, child) {
                              var BMR = (10 * health.weight) +
                                  (6.25 * health.height) -
                                  5 * (user.info?.age ?? 25);
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
                            }),
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
                                  provider.recommendedCalories
                                      .toStringAsFixed(2),
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade600,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.35,
                                  height: MediaQuery.of(context).size.height *
                                      0.025,
                                  child: CustomButton(
                                    onPressed: () async {
                                      _showBottomSheet(context);
                                    },
                                    text: const Text(
                                      "식단 리포트 확인",
                                      style: TextStyle(fontSize: 10),
                                    ),
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
                                              color: Colors.blueGrey,
                                              fontSize: 15),
                                        ),
                                        Icon(Icons.analytics)
                                      ]),
                                  SizedBox(height: 25),
                                  NutritionInfo(),
                                ]))),
                  ],
                ),
              ),
            ));
      },
    );
  }

  double _findMaxCalories(
      double todayCalories, double weeklyCalories, double monthlyCalories) {
    double max = todayCalories;
    if (weeklyCalories > max) {
      max = weeklyCalories;
    }
    if (monthlyCalories > max) {
      max = monthlyCalories;
    }
    if (max == 0) {
      max = 1;
    }
    return max;
  }

  void _showBottomSheet(BuildContext context) {
    final provider = Provider.of<DietProvider>(context, listen: false);
    double max = _findMaxCalories(provider.totalNutritionalInfo.calories,
        provider.averageCaloriesForWeek, provider.averageCaloriesForMonth);

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      isScrollControlled: true,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        "${provider.selectedDay.year}년 ${provider.selectedDay.month}월 식단 리포트",
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
                const SizedBox(height: 25),
                // 주간 및 월간 평균 칼로리를 표시하는 그래프 추가
                Column(
                  children: [
                    if (provider.totalNutritionalInfo.calories == 0)
                      Column(children: [
                        Text(
                          '${provider.selectedDay.day}일은 식단 데이터가 없어요. 식단을 기록할까요?',
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 25),
                      ]),
                    if (provider.averageCaloriesForWeek == 0)
                      const Column(children: [
                        Text(
                          '주간 식단 데이터가 없어요. 식단을 기록할까요?',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 25),
                      ]),
                    if (provider.averageCaloriesForMonth == 0)
                      const Column(children: [
                        Text(
                          '월간 식단 데이터가 없어요. 식단을 기록할까요?',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 25),
                      ]),
                    if (provider.totalNutritionalInfo.calories != 0)
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Flexible(
                                child: Text(
                                  "${provider.selectedDay.day}일은 ${provider.getWeeklyCaloriesComparisonMessage(
                                    provider.totalNutritionalInfo.calories,
                                    provider.averageCaloriesForWeek,
                                  )}",
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Flexible(
                                child: Text(
                                  " ${provider.getMonthlyCaloriesComparisonMessage(provider.totalNutritionalInfo.calories, provider.averageCaloriesForMonth)} 섭취했어요!",
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 25),
                        ],
                      ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "${provider.selectedDay.day}일",
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            '${provider.totalNutritionalInfo.calories.toStringAsFixed(1)} kcal',
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        value: provider.totalNutritionalInfo.calories / max,
                        backgroundColor: Colors.grey[300],
                        valueColor:
                            const AlwaysStoppedAnimation<Color>(Colors.teal),
                        minHeight: 10,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Text(
                          "주간 평균",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            '${provider.averageCaloriesForWeek.toStringAsFixed(1)} kcal',
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        value: provider.averageCaloriesForWeek / max,
                        backgroundColor: Colors.grey[300],
                        valueColor: const AlwaysStoppedAnimation<Color>(
                            Colors.blueAccent),
                        minHeight: 10,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Text(
                          "월간 평균",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            '${provider.averageCaloriesForMonth.toStringAsFixed(1)} kcal',
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        value: provider.averageCaloriesForMonth / max,
                        backgroundColor: Colors.grey[300],
                        valueColor: const AlwaysStoppedAnimation<Color>(
                            Colors.redAccent),
                        minHeight: 10,
                      ),
                    ),
                    const SizedBox(height: 25),
                  ],
                ),
                SizedBox(
                  width: double.maxFinite,
                  child: FilledButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 8.0),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DietSearchPage(),
                        ),
                      );
                    },
                    child: const Text('식단 기록하기'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
