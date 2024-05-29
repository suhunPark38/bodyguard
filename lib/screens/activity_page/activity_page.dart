import 'dart:io';

import 'package:bodyguard/providers/health_data_provider.dart';
import 'package:bodyguard/screens/activity_page/widgets/body_info_widget.dart';
import 'package:bodyguard/screens/activity_page/widgets/calorie_widget.dart';
import 'package:bodyguard/screens/activity_page/widgets/date_widget.dart';
import 'package:bodyguard/screens/activity_page/widgets/steps_widget.dart';
import 'package:bodyguard/screens/activity_page/widgets/water_widget.dart';
import 'package:bodyguard/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:health/health.dart';
import 'package:provider/provider.dart';



class ActivityPage extends StatefulWidget {
  const ActivityPage({Key? key}) : super(key: key);

  @override
  _ActivityPageState createState() => _ActivityPageState();
}

class _ActivityPageState extends State<ActivityPage> {

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Center(
          child: Consumer<HealthDataProvider>(
            builder: (context, provider, _) => Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  DateWidget(),
                  StepsWidget(currentSteps: provider.steps),
                  WaterWidget(water: provider.water),
                  CalorieWidget(targetCalories: 2000, burnedCalories: provider.totalCalorie),
                  BodyInfoWidget(height: provider.height, weight: provider.weight),

                  if(Platform.isAndroid) // 헬스 커넥트는 안드로이드에서만 실행 가능하다.
                    CustomButton(
                      onPressed: () {
                        Health().installHealthConnect();
                      }, text: const Text('헬스 커넥트 열기'),
                    ),
                ]),

          )
      ),
    );

  }
}

