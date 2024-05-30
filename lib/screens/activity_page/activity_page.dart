import 'package:bodyguard/providers/health_data_provider.dart';
import 'package:bodyguard/screens/activity_page/widgets/body_info_widget.dart';
import 'package:bodyguard/screens/activity_page/widgets/calorie_widget.dart';
import 'package:bodyguard/screens/activity_page/widgets/date_widget.dart';
import 'package:bodyguard/screens/activity_page/widgets/steps_widget.dart';
import 'package:bodyguard/screens/activity_page/widgets/water_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class ActivityPage extends StatelessWidget {
  const ActivityPage({super.key});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        Provider.of<HealthDataProvider>(context, listen: false).todayDate();
      },
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Center(
            child: Consumer<HealthDataProvider>(
          builder: (context, provider, _) =>
              Column(mainAxisAlignment: MainAxisAlignment.start, children: [
            DateWidget(),
            StepsWidget(currentSteps: provider.steps),
            const SizedBox(height: 10),
            WaterWidget(water: provider.water),
            const SizedBox(height: 10),
            CalorieWidget(
              burnedCalories: provider.totalCalorie,
              targetCalorie: provider.targetCalorie,
            ),
            const SizedBox(height: 10),
            BodyInfoWidget(),
            const SizedBox(height: 10),
            /*if (Platform.isAndroid) // 헬스 커넥트는 안드로이드에서만 실행 가능하다.
              CustomButton(
                onPressed: () {
                  Health().installHealthConnect();
                },
                text: const Text('헬스 커넥트 열기'),
              ),*/
          ]),
        )),
      ),
    );
  }
}
