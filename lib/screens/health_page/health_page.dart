import 'package:bodyguard/screens/activity_page/activity_page.dart';
import 'package:flutter/material.dart';

import '../../widgets/custom_button.dart';
import '../diet_page/diet_page.dart';
import '../diet_search_page/diet_search_page.dart';

class HealthPage extends StatelessWidget {
  final int initailIndex;

  const HealthPage({super.key, required this.initailIndex});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: initailIndex,
        length: 2,
        child: Scaffold(
            appBar: AppBar(
              title:const TabBar(
                tabs: [
                  Tab(text: "식단"),
                  Tab(text: "활동"),
                ],
              ),
            ),
            body: const TabBarView(
              children: [
                DietPage(),
                ActivityPage(),
              ],
            ),
            persistentFooterButtons: [
              SizedBox(
                  width: double.maxFinite,
                  height: 40,
                  child: CustomButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DietSearchPage(),
                        ),
                      );
                    },
                    text: const Text('식단 기록하기'),
                  )),
            ]));
  }
}
