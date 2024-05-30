import 'package:bodyguard/providers/health_data_provider.dart';
import 'package:bodyguard/providers/user_info_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/user_firebase.dart';
import '../../utils/regExp.dart';
import '../../widgets/custom_form.dart';

class BodyPage extends StatefulWidget {
  const BodyPage({Key? key}) : super(key: key);

  @override
  _BodyPageState createState() => _BodyPageState();
}

class _BodyPageState extends State<BodyPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final FocusNode _heightNode = FocusNode();
  final FocusNode _weightNode = FocusNode();
  final FocusNode _ageNode = FocusNode();

  late double _bmi;
  double? _skeletalMuscleMass;
  double? _bodyFat;
  final ValueNotifier<bool> _isCheckedNotifier = ValueNotifier(false);
  bool _isLoading = false;
  bool _isInitialized = false;

  void _showLoadingSnackBar() {
    Future.delayed(Duration(seconds: 2), () {
      if (_isLoading) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Loading is taking longer than expected')),
        );
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  void initInfoText() {
    final user = Provider.of<UserInfoProvider>(context, listen: false);
    // 텍스트 필드의 초기값을 설정
    _weightController.text = (user.info?.weight ?? 0.0).toString();
    _heightController.text = (user.info?.height ?? 0.0).toString();
    _ageController.text = (user.info?.age ?? 0).toString();
    _genderController.text = user.info?.gender ?? "남";
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      initInfoText();
      _isInitialized = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('인바디 정보 확인'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: inputForm(),
      ),
    );
  }

  Form inputForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CustomForm().buildTextField(
            label: '나이',
            controller: _ageController,
            focusNode: _ageNode,
            keyboardType: TextInputType.number,
            regExp: REGEXP.age,
            errorText: "나이가 너무 많습니다.",
          ),
          CustomForm().buildTextField(
            label: '키 (cm)',
            controller: _heightController,
            focusNode: _heightNode,
            keyboardType: TextInputType.number,
            regExp: REGEXP.number,
          ),
          CustomForm().buildTextField(
            label: '몸무게 (kg)',
            controller: _weightController,
            focusNode: _weightNode,
            keyboardType: TextInputType.number,
            regExp: REGEXP.number,
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: Row(
              children: [
                ValueListenableBuilder<bool>(
                  valueListenable: _isCheckedNotifier,
                  builder: (context, isChecked, child) {
                    return Checkbox(
                      value: isChecked,
                      onChanged: (bool? value) {
                        _isCheckedNotifier.value = value ?? false;
                      },
                    );
                  },
                ),
                Text('변경된 데이터(키, 몸무게) 내정보에 저장하기'),
              ],
            ),
          ),
          CustomForm().genderSelectField(
            controller: _genderController,
            context: context,
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              setState(() {
                _isLoading = true;
              });
              _showLoadingSnackBar();
              if (_formKey.currentState!.validate()) {
                _calculateBodyComposition();
              }
              setState(() {
                _isLoading = false;
              });
            },
            child: _isLoading
                ? CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            )
                : Text('계산하기'),
          ),
          SizedBox(height: 10),
          if (_bodyFat != null && _skeletalMuscleMass != null)
            Column(
              children: [
                Text(
                  "※ 아래 결과는 참고용입니다.\n정확한 정보는 전문가의 상담을 받으세요.",
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildResultTile(
                          title: '골격근량',
                          unit: 'kg',
                          value: _skeletalMuscleMass!,
                          range: _genderController.text == '남'
                              ? [33, 39]
                              : [24, 30],
                        ),
                        Divider(),
                        _buildResultTile(
                          title: '체지방',
                          unit: '%',
                          value: _bodyFat!,
                          range: _genderController.text == '남'
                              ? [10, 20]
                              : [18, 28],
                        ),
                        Divider(),
                        _buildResultTile(
                          title: 'BMI',
                          unit: '',
                          value: _bmi,
                          range: [18.5, 24.9],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  void _calculateBodyComposition() {
    double height = double.tryParse(_heightController.text) ?? 0;
    double weight = double.tryParse(_weightController.text) ?? 0;
    int age = int.tryParse(_ageController.text) ?? 0;
    print(height);
    print(weight);
    print(age);

    if (_isCheckedNotifier.value) {
      Provider.of<UserInfoProvider>(context, listen: false).height = height;
      Provider.of<UserInfoProvider>(context, listen: false).weight = weight;
      Provider.of<UserInfoProvider>(context, listen: false).age = age;
      Provider.of<UserInfoProvider>(context, listen: false).gender = _genderController.text;
    }

    double heightMeter = height / 100; // 키를 미터로 변환
    _bmi = weight / (heightMeter * heightMeter); // BMI 계산
    setState(() {
      if (_genderController.text == '남') {
        _skeletalMuscleMass =
            0.5 * weight + 0.3 * age - 0.02 * _bmi * _bmi + 0.5;
        _bodyFat = 1.2 * _bmi + 0.23 * age - 16.2;
      } else if (_genderController.text == '여') {
        _skeletalMuscleMass =
            0.5 * weight + 0.3 * age - 0.02 * _bmi * _bmi - 0.5;
        _bodyFat = 1.2 * _bmi + 0.23 * age - 5.4;
      } else {
        _skeletalMuscleMass = null;
        _bodyFat = null;
        return;
      }
    });
  }

  Widget _buildResultTile(
      {required String title,
        required double value,
        required String unit,
        required List<double> range}) {
    Color color;
    String statusText;
    if (value <= 0) {
      color = Colors.orange;
      statusText = '가능하지 않는 수치입니다.\n 다시 입력하세요';
    }
    else if (value < range[0]) {
      color = Colors.blue;
      statusText = '정상범위보다 낮습니다.';
    } else if (range[1] < value) {
      color = Colors.red;
      statusText = '정상범위보다 높습니다.';
      if(title == "골격근량"){
        color = Colors.green;
        statusText = '정상범위보다 좋습니다.';
      }
    } else {
      color = Colors.green;
      statusText = '정상범위안에 있습니다';
    }

    return ListTile(
      leading: Icon(
        color == Colors.green ? Icons.check_circle : Icons.warning,
        color: color,
      ),
      title: Text(
        title,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        '${value.toStringAsFixed(2)} $unit',
        style: TextStyle(color: color),
      ),
      trailing: Text(
        statusText,
      ),
    );
  }
}
