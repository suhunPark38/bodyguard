import 'package:flutter/material.dart';

import '../map.dart';


class ShoppingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        centerTitle: true,
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {

            Widget mapPage = await MapRun(); // MapRun 실행하여 Widget 받기
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => mapPage, // 받은 Widget으로 화면 전환
              ),
            );
          },
          child: const Text('칼로리 입력 화면'),
        ),
      ),
    );
  }
}
