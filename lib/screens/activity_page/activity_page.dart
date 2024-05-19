import 'package:bodyguard/providers/health_data_provider.dart';
import 'package:bodyguard/screens/activity_page/widgets/body_info_widget.dart';
import 'package:bodyguard/screens/activity_page/widgets/calorie_widget.dart';
import 'package:bodyguard/screens/activity_page/widgets/date_widget.dart';
import 'package:bodyguard/screens/activity_page/widgets/exercise_widget.dart';
import 'package:bodyguard/screens/activity_page/widgets/steps_widget.dart';
import 'package:bodyguard/screens/activity_page/widgets/water_widget.dart';
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
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '건강 기록 확인',
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back),
        ),
        actions: const <Widget>[],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Consumer<HealthDataProvider>(
            builder: (context, provider, _)
              => Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    DateWidget(),
                    StepsWidget(currentSteps: provider.steps, targetSteps: 6000),
                    WaterWidget(water: provider.water),
                    CalorieWidget(targetCalorie: provider.totalCalorie, burnedCalorie: 150.0),
                    ExerciseWidget(),
                    BodyInfoWidget(height: provider.height, weight: provider.weight),

                  ]),

          )
        ),
      ),
    );

  }
}

