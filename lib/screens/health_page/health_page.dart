import 'package:flutter/material.dart';

class HealthPage extends StatelessWidget {
  const HealthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("BODYGUARD"),
          bottom: const TabBar(
            tabs: [
              Tab(text: "식단"),
              Tab(text: "활동"),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            Center(child: Text("식단")),
            Center(child: Text("활동")),
          ],
        ),
      ),
    );
  }
}
