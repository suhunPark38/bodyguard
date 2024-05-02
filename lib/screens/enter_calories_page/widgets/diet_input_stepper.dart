import 'package:flutter/material.dart';

class DietInputStepper extends StatefulWidget {
  @override
  _DietInputStepperState createState() => _DietInputStepperState();
}

class _DietInputStepperState extends State<DietInputStepper> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return Stepper(
      currentStep: _index,

      onStepCancel: () {
        if (_index > 0) {
          setState(() {
            _index -= 1;
          });
        }
      },

      onStepContinue: () {
          setState(() {
            _index += 1;
          });
      },

      onStepTapped: (int step) {
        setState(() {
          _index = step;
        });
      },


      steps: [
        Step(
          title: Text('메뉴 검색'),
          content: Container(
            child: Text('검색어를 입력하여 메뉴를 찾아보세요.'),
          ),
          isActive: _index == 0,
        ),
        Step(
          title: Text('메뉴 선택'),
          content: Container(
            child: Text('검색 결과에서 원하는 메뉴를 선택하세요.'),
          ),
          isActive: _index == 1,
        ),
        Step(
          title: Text('세부 정보 입력'),
          content: Container(
            child: Text('선택한 메뉴에 대한 세부 정보를 입력하세요.'),
          ),
          isActive: _index == 2,
        ),
      ],

    );
  }
}
