import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'home.dart';
import 'screens/home_page/my_home_page.dart';

void main() {
  initializeDateFormatting().then((_) => runApp(const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(

      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],

      supportedLocales: [
        const Locale('ko', 'KR'),
      ],

      home: MyHomePage(),
    );

  }
}
