import 'package:reminder/domain/entities/notification_entities.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:reminder/core/localnotification_setup.dart';
import 'package:timezone/timezone.dart' as tz;

class SetAlarmUsecase{
  
  Future<void> execute(Notification notificationInfo) async {
    NotificationDetails notificationDetails() {
        return const NotificationDetails(
          android: AndroidNotificationDetails(
            'daily_channel_id',
            'Daily Notificatioin',
            channelDescription: 'This channel is used for daily notifications',
            importance: Importance.max,
            priority: Priority.high,

            playSound: true,
            enableVibration: true,
            fullScreenIntent: true,  // 잠금화면에서도 표시
            category: AndroidNotificationCategory.alarm,
            visibility: NotificationVisibility.public,
          ),
        );
      }
    final String timeValue = notificationInfo.timevalue;
    final List<String> timeComponents = timeValue.split('_');
    final int year = int.parse(timeComponents[0]);
    final int month = int.parse(timeComponents[1]);
    final int day = int.parse(timeComponents[2]);
    final int hour = int.parse(timeComponents[3]);
    final int minute = int.parse(timeComponents[4]);

    final nextInstance = tz.TZDateTime(
      tz.local,
      year,
      month,
      day,
      hour,
      minute,
    );
    await FlutterLocalNotification().notificationsPlugin.zonedSchedule(
      notificationInfo.notificationId, // 알림 ID
      notificationInfo.title,
      notificationInfo.description,
      nextInstance.isBefore(tz.TZDateTime.now(tz.local))
          ? nextInstance.add(const Duration(days: 1)) // 오늘 시간이 이미 지났으면 내일로
          : nextInstance,
      notificationDetails(),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time, // 🔁 매일 반복
    );
  }
}