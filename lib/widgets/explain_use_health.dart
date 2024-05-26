import 'package:flutter/material.dart';
import 'package:health/health.dart';

class ExplainUseHealth extends StatefulWidget {
  @override
  _ExplainUseHealthState createState() => _ExplainUseHealthState();
}

class _ExplainUseHealthState extends State<ExplainUseHealth> {
  int _currentStep = 0;

  final List<String> _imageAssets = [
    'assets/image/health_setting1.png',
    'assets/image/health_setting2.png',
    'assets/image/health_setting3.png',
  ];

  final List<String> _descriptions = [
    '앱 권한을 클릭해주세요.',
    'bodyguard 앱을 클릭해주세요.',
    '권한을 모두 허용해주세요.',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text( "헬스 커넥트 연동하기"),
      ),
      body: Stepper(
        type: StepperType.horizontal,
        currentStep: _currentStep,
        onStepTapped: (step) => setState(() => _currentStep = step),
        onStepContinue: () {
          if (_currentStep < _imageAssets.length - 1) {
            setState(() => _currentStep += 1);
          } else {
            Health().installHealthConnect();
            Navigator.of(context).pop(); // 마지막 단계에서 닫기
          }
        },
        onStepCancel: _currentStep > 0 ? () => setState(() => _currentStep -= 1) : null,
        steps: [
          for (int i = 0; i < _imageAssets.length; i++)
            Step(
              title: Text('단계 ${i + 1}'),
              content: Column(
                children: [
                  SizedBox(
                    child: Image.asset(_imageAssets[i]),
                    height: 600,
                  ),
                  SizedBox(height: 10),
                  Text(_descriptions[i],
                      style: const TextStyle(fontSize: 18),
                  ),
                ],
              ),
              isActive: _currentStep >= i,
              state: _currentStep >= i ? StepState.complete : StepState.indexed,
            ),
        ],
        controlsBuilder: (BuildContext context, ControlsDetails details) {
          final isLastStep = _currentStep == _imageAssets.length - 1;
          return Row(
            children: <Widget>[
              if (_currentStep > 0)
                TextButton(
                  onPressed: details.onStepCancel,
                  child: const Text('이전', style: TextStyle(fontSize: 16)),
                ),
              TextButton(
                onPressed: details.onStepContinue,
                child: Text(isLastStep ? '마무리 하기' : '다음', style: TextStyle(fontSize: 16)),
              ),
            ],
          );
        },
      ),
    );
  }
}
