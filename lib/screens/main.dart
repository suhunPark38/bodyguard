import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'my_home_page.dart';

void main() {
  initializeDateFormatting().then((_) => runApp(const MyApp()));
}

class NutritionalData {
  final double calories;
  final double carbohydrates;
  final double protein;
  final double fat;
  final double sodium;
  final double sugar;
  final int waterIntake;
  final int steps;

  NutritionalData({
    required this.calories,
    required this.carbohydrates,
    required this.protein,
    required this.fat,
    required this.sodium,
    required this.sugar,
    required this.waterIntake,
    required this.steps,
  });
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyHomePage(),
    );
  }
}
