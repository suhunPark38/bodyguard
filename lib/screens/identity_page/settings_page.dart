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

                    // 알림이 켜졌을 때 스낵바 표시
                    if (notificationProvider.enableNotifications) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('알림이 활성화되었습니다.'),
                        ),
                      );
                    }
                    // 알림이 꺼졌을 때 스낵바 표시
                    else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('알림이 비활성화되었습니다.'),
                        ),
                      );
                    }
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
