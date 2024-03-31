import 'package:flutter/material.dart';

import 'enter_calories_page.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        centerTitle: true,
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MyEnterCaloriesPage(), // 서브페이지로 이동합니다.
              ),
            );
          },
          child: const Text('칼로리 입력 화면'),
        ),
      ),
    );
  }
}
