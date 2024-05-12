import 'package:bodyguard/screens/diet_page/widgets/diet_calendar.dart';
import 'package:bodyguard/screens/diet_page/widgets/diet_search_screen.dart';
import 'package:bodyguard/screens/diet_page/widgets/diets_card.dart';
import 'package:flutter/material.dart';

import 'package:bodyguard/providers/diet_provider.dart';
import 'package:provider/provider.dart';

import '../../utils/format_util.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/nutrition_info.dart';

class DietPage extends StatelessWidget {
  const DietPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<DietProvider>(
      builder: (context, provider, child) {
        final DateTime now = DateTime.utc(
            DateTime.now().year, DateTime.now().month, DateTime.now().day);

        return Scaffold(
          appBar: AppBar(
            title: const Text(
              '식단 다이어리',
            ),
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back),
            ),
            actions: const <Widget>[],
          ),
          body: SingleChildScrollView(
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
                        Row(children: [
                          const SizedBox(width: 8),
                          Text(
                            '${provider.selectedDay.day}',
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(width: 8),
                          Text('${getWeekday(provider.selectedDay)}요일'),
                        ]),
                        SizedBox(
                            width: 90,
                            height: 20,
                            child: CustomButton(
                              onPressed: () {
                                provider.setSelectedDay(now);
                                provider
                                    .notifySelectDiets(provider.selectedDay);
                                provider.setFocusedDay(now);
                              },
                              text: const Text(
                                "오늘 날짜로",
                                style: TextStyle(fontSize: 9),
                              ),
                            )),
                      ]),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.25,
                    child:  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        DietsCard(
                          classification: 0,
                          cardColor: Colors.orange.shade50,
                        ),
                        DietsCard(
                          classification: 1,
                          cardColor: Colors.green.shade50,
                        ),
                        DietsCard(
                          classification: 2,
                          cardColor: Colors.blue.shade50,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(children: [
                          const SizedBox(width: 8),
                          Text(
                            '총 ${provider.totalNutritionalInfo.calories.toStringAsFixed(1)}kcal',
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          )
                        ]),
                      ]),
                  const SizedBox(height: 20),
                  const NutritionInfo(),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DietSearchScreen()),
              );
            },
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }
}
