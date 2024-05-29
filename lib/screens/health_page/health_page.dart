import 'package:bodyguard/screens/activity_page/activity_page.dart';
import 'package:flutter/material.dart';

import '../../widgets/custom_button.dart';
import '../diet_page/diet_page.dart';
import '../diet_search_page/diet_search_page.dart';

class HealthPage extends StatelessWidget {
  final int initialIndex;

  const HealthPage({super.key, required this.initialIndex});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: initialIndex,
      length: 2,
      child: Builder(
        builder: (context) {
          final TabController tabController = DefaultTabController.of(context);
          return Scaffold(
            appBar: AppBar(
              title: const TabBar(
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
              ValueListenableBuilder<int>(
                valueListenable: tabController.animation!.drive(IntTween(begin: 0, end: 1)),
                builder: (context, value, child) {
                  return value == 0
                      ? SizedBox(
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
                    ),
                  )
                      : const SizedBox.shrink();
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
