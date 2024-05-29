import 'package:flutter/material.dart';
import '../database/notification_database.dart';

class NotificationProvider with ChangeNotifier {
  bool _enableNotifications = true;

  bool get enableNotifications => _enableNotifications;

  NotificationProvider() {
    _loadNotificationPreference();
  }

  void _loadNotificationPreference() async {
    _enableNotifications = await NotificationDatabase().isNotificationEnabled();
    notifyListeners();
  }

  void setNotificationPreference(bool value) async {
    _enableNotifications = value;
    await NotificationDatabase().setNotificationEnabled(value);
    notifyListeners();
  }

  IconData get notificationIcon {
    return _enableNotifications ? Icons.notifications : Icons.notifications_off;
  }
}
