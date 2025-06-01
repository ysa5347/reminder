import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class FlutterLocalNotification{
  final FlutterLocalNotificationsPlugin notificationsPlugin = 
    FlutterLocalNotificationsPlugin();

    Future<void> initNotification() async {
      tz.initializeTimeZones();

      const initializationSettingsAndroid = 
        AndroidInitializationSettings('mipmap/ic_launcher');

      const InitializationSettings initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid,
      );

      await notificationsPlugin.initialize(
        initializationSettings,
        onDidReceiveNotificationResponse: (NotificationResponse response) async {
          // 알림 클릭 시 처리할 로직
          print('알림 클릭됨: ${response.payload}');
        },
      );
      await notificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.requestNotificationsPermission();

    }
    /*
    나중에 이동시켜야함
    NotificationDetails notificationDetails() {
        return const NotificationDetails(
          android: AndroidNotificationDetails(
            'daily_channel_id',
            'Daily Notificatioin',
            channelDescription: 'Daily Notification Channel',
            importance: Importance.max,
            priority: Priority.high,
          ),
        );
    }
    */
}