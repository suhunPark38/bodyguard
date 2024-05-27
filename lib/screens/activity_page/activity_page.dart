import 'package:bodyguard/providers/health_data_provider.dart';
import 'package:bodyguard/screens/activity_page/widgets/body_info_widget.dart';
import 'package:bodyguard/screens/activity_page/widgets/calorie_widget.dart';
import 'package:bodyguard/screens/activity_page/widgets/date_widget.dart';
import 'package:bodyguard/screens/activity_page/widgets/steps_widget.dart';
import 'package:bodyguard/screens/activity_page/widgets/water_widget.dart';
import 'package:bodyguard/widgets/custom_button.dart';
import 'package:bodyguard/widgets/explain_use_health.dart';
import 'package:flutter/material.dart';
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
                  CustomButton(
                    onPressed: () {  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ExplainUseHealth()), // ImageStepper 페이지로 이동
                    );}, text: const Text('건강 데이터 연동에 실패한다면?'),
                  ),
                ]),

          )
      ),
    );

  }
}

