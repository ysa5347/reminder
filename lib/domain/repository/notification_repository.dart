import 'package:reminder/domain/entities/notification_entities.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

abstract class NotificationRepository {
  Future<Notification> showNotification(String timeValue);  //show user notification
  Future<Notification> saveNotification(String timeValue, String title);
  Future<Notification> deleteNotification(int notificationId); //delete notification that has same notification id
}

abstract class AlarmRepository{
  Future<void> setAlarm(String timeValue); //set alarm. it may run in domain
  Future<void> deleteAlarm(int notificatinoId);
}