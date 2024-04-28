import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State
{
bool _enableNotifications = true; // 알림 활성화 여부를 저장할 변수

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text('설정'),
    ),
    body: ListView(
      children: <Widget>[
        ListTile(
          title: Text('알림 설정'),
          trailing: Switch(
            value: _enableNotifications,
            onChanged: (value) {
              setState(() {
                _enableNotifications = value;
              });
            },
          ),
        ),
        // 여기에 추가적인 설정 항목들을 넣을 수 있습니다.
      ],
    ),
  );
}
}
