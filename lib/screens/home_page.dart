import 'package:flutter/material.dart';
import 'enter_calories_page.dart';
import 'activity_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        centerTitle: true,
      ),
      body: Column(children: [
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const MyEnterCaloriesPage(),
              ),
            );
          },
          child: const Text('칼로리 입력 화면'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ActivityPage(),
              ),
            );
          },
          child: const Text('활동 화면'),
        ),
      ]),
    );
  }
}
