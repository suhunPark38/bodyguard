import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'my_home_page.dart';

void main() {
  initializeDateFormatting().then((_) => runApp(const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(

      home: MyHomePage(),
    );
    //이거 기범이 코드 실행방법
    //return MaterialApp(
    //
    //       home: SecondScreen(),
    //     );

  }
}
