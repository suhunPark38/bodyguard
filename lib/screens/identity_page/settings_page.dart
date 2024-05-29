import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/notification_provider.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('설정'),
      ),
      body: ListView(
        children: <Widget>[
          Consumer<NotificationProvider>(
            builder: (context, notificationProvider, child) {
              return ListTile(
                title: Text('알림 설정'),
                trailing: Switch(
                  value: notificationProvider.enableNotifications,
                  onChanged: (value) {
                    notificationProvider.setNotificationPreference(value);
                  },
                ),
              );
            },
          ),
          // 여기에 추가적인 설정 항목들을 넣을 수 있습니다.
        ],
      ),
    );
  }
}
