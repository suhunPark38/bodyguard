import 'dart:io' show Platform;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class FlutterLocalNotification {
  // private constructor to prevent instantiation
  FlutterLocalNotification._();

  // instance of the FlutterLocalNotificationsPlugin
  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // Initialize the notification plugin
  static Future<void> init() async {
    AndroidInitializationSettings androidInitializationSettings =
        const AndroidInitializationSettings('mipmap/ic_launcher');

    DarwinInitializationSettings iosInitializationSettings =
        const DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    InitializationSettings initializationSettings = InitializationSettings(
      android: androidInitializationSettings,
      iOS: iosInitializationSettings,
    );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  // Request permission for receiving notifications based on the platform
  static void requestNotificationPermission() {
    if (Platform.isAndroid) {
      flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.requestNotificationsPermission();
    } else if (Platform.isIOS) {
      flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
    }
  }

  // Show a test notification
  static Future<void> showNotification(
      int id, String channelName, String title, String body) async {
    final AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      '', // 채널 ID
      channelName, // 채널 이름
      channelDescription: '',
      // 채널 설명
      importance: Importance.max,
      priority: Priority.high,
      showWhen: true,
      groupKey: channelName,
      setAsGroupSummary: false, // 그룹 요약 알림을 생성하지 않음
    );

    final NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: DarwinNotificationDetails(badgeNumber: 1),
    );

    await flutterLocalNotificationsPlugin.show(
        id, title, body, notificationDetails);
  }

  // Show a grouped summary notification
  static Future<void> showGroupSummaryNotification(String channelName) async {
    final AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
            '', // 채널 ID
            channelName, // 채널 이름
            channelDescription: '',
            // 채널 설명
            importance: Importance.max,
            priority: Priority.high,
            showWhen: true,
            groupKey: channelName,
            setAsGroupSummary: true,
            // 그룹 요약 알림 생성
            onlyAlertOnce: true);

    final NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: DarwinNotificationDetails(badgeNumber: 1),
    );

    await flutterLocalNotificationsPlugin.show(
        0, '', '', notificationDetails);
  }
}
