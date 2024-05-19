import 'package:flutter/material.dart';

import '../../widgets/custom_button.dart';
import '../diet_page/diet_page.dart';
import '../diet_search_page/diet_search_page.dart';

class HealthPage extends StatelessWidget {
  const HealthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
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
                Center(child: Text("활동")),
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
