import 'package:flutter/material.dart';

class BodyPage extends StatefulWidget {
  const BodyPage({Key? key}) : super(key: key);

  @override
  _BodyPageState createState() => _BodyPageState();
}

class _BodyPageState extends State<BodyPage> {
  TextEditingController _heightController = TextEditingController();
  TextEditingController _weightController = TextEditingController();
  TextEditingController _ageController = TextEditingController();
  TextEditingController _genderController = TextEditingController();

  double? _skeletalMuscleMass;
  double? _bodyFat;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('인바디 정보 수정'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _heightController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: '키 (cm)',
              ),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: _weightController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: '몸무게 (kg)',
              ),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: _ageController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: '나이',
              ),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: _genderController,
              decoration: InputDecoration(
                labelText: '성별 (남성: M, 여성: F)',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _calculateBodyComposition();
              },
              child: Text('계산하기'),
            ),
            SizedBox(height: 20),
            if (_skeletalMuscleMass != null && _bodyFat != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text('골격근량: ${_skeletalMuscleMass!.toStringAsFixed(2)} kg'),
                  SizedBox(height: 10),
                  Text('체지방: ${_bodyFat!.toStringAsFixed(2)} %'),
                ],
              ),

          ],
        ),
      ),
    );
  }

  void _calculateBodyComposition() {
    // 키, 몸무게, 나이, 성별을 가져오기
    double height = double.tryParse(_heightController.text) ?? 0;
    double weight = double.tryParse(_weightController.text) ?? 0;
    int age = int.tryParse(_ageController.text) ?? 0;
    String gender = _genderController.text.toUpperCase();

    // 예시 공식을 사용하여 골격근량과 체지방률 계산
    // 이 부분은 실제 공식으로 대체되어야 합니다.
    double heightMeter = height / 100; // 키를 미터로 변환
    double bmi = weight / (heightMeter * heightMeter); // BMI 계산

    if (gender == 'M') {
      _skeletalMuscleMass = 0.5 * weight + 0.3 * age - 0.02 * bmi * bmi + 0.5;
      _bodyFat = 0.02 * age + 0.3 * bmi - 10.8 * 0 - 5.4;
    } else if (gender == 'F') {
      _skeletalMuscleMass = 0.5 * weight + 0.3 * age - 0.02 * bmi * bmi - 0.5;
      _bodyFat = 0.02 * age + 0.3 * bmi - 10.8 * 1 - 5.4;
    } else {
      _skeletalMuscleMass = null;
      _bodyFat = null;
      return;
    }

    setState(() {});
  }

  @override
  void dispose() {
    _heightController.dispose();
    _weightController.dispose();
    _ageController.dispose();
    _genderController.dispose();
    super.dispose();
  }
}
