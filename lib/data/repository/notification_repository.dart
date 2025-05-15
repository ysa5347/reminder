import 'package:flutter/material.dart' as material;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:reminder/domain/repository/notification_repository.dart';
import 'package:reminder/domain/entities/notification_entities.dart';

class NotificationRepositoryImpl extends NotificationRepository {
  @override
  Future<Notification> saveNotification() async {
    return Notification(
      '12', // timeHour
      '00', // timeMinute
      '00', // timeSecond
      text: 'New Reminder',
      timeDate: DateTime.now().toString(),
    );
  }

  @override
  Future<void> showNotification() async {
    // TODO: implement showNotification
    throw UnimplementedError();
    //get timeHour, timeMinute, timeSecond ->
    
  }

  /*
  @override
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