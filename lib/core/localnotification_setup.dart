import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class FlutterLocalNotification{
  final FlutterLocalNotificationsPlugin notificationsPlugin = 
    FlutterLocalNotificationsPlugin();

    Future<void> initNotification() async {

      const initializationSettingsAndroid = 
        AndroidInitializationSettings('mipmap/ic_launcher');

      const InitializationSettings initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid,
      );

      await notificationsPlugin.initialize(
        initializationSettings,
        //onDidReceiveNotificationResponse: (NotificationResponse response) async {}
      );
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