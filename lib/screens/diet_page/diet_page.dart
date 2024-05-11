import 'package:bodyguard/screens/diet_page/widgets/diet_calendar.dart';
import 'package:bodyguard/screens/diet_page/widgets/diet_search_screen.dart';
import 'package:bodyguard/screens/diet_page/widgets/diets_card.dart';
import 'package:flutter/material.dart';

import 'package:bodyguard/providers/diet_provider.dart';
import 'package:provider/provider.dart';

import '../../widgets/nutrition_info.dart';

class DietPage extends StatelessWidget {
  const DietPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<DietProvider>(
      builder: (context, provider, child) {
        final DateTime now = DateTime.utc(DateTime.now().year, DateTime.now().month, DateTime.now().day);


        return Scaffold(
          appBar: AppBar(
            title: const Text(
              '식단 기록',
            ),
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  provider.setSelectedDay(now);
                  provider.notifySelectDiets(provider.selectedDay);
                  provider.setFocusedDay(now);
                },
               child: const Text("오늘 날짜로"),
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(8),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const DietCalendar(),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.25,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        DietsCard(
                          classification: 0,
                          //cardColor: Colors.amber.shade50, 젠장 색상이 내 맘대로 안돼!
                        ),
                        DietsCard(
                          classification: 1,
                          //cardColor: Colors.red.shade50,
                        ),
                        DietsCard(
                          classification: 2,
                          //cardColor: Colors.cyan.shade50,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                 // const NutritionInfo(),
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
