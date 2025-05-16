import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:reminder/core/localnotification_setup.dart';
import 'package:reminder/domain/repository/notification_repository.dart';
import 'package:timezone/timezone.dart' as tz;

class SetAlarmUsecase{
  final AlarmRepository alarmRepository;
  SetAlarmUsecase({required this.alarmRepository});

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

  Future<void> scheduleDailyReminder({
  //required String dateValue, 이것도 파싱해서?
  required int year,
  required int month,
  required int date,
  required int hour,
  required int minute,
  String? title,
  String? body,
  String? payload,
  }) async {
    //final scheduledTime = tz.TZDateTime.now(tz.local).add(const Duration(seconds: 1));
    final nextInstance = tz.TZDateTime(
      tz.local,
      year,
      month,
      date,
      hour,
      minute,
    );

    await FlutterLocalNotification().notificationsPlugin.zonedSchedule( //이것도 dependency에 위배되나요?
      1, // 알림 ID
      title,
      body,
      nextInstance.isBefore(tz.TZDateTime.now(tz.local))
          ? nextInstance.add(const Duration(days: 1)) // 오늘 시간이 이미 지났으면 내일로
          : nextInstance,
      notificationDetails(),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      payload: payload,
      matchDateTimeComponents: DateTimeComponents.time, // 🔁 매일 반복
    );
  }
}
