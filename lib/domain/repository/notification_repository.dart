import 'package:reminder/domain/entities/notification_entities.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

abstract class NotificationRepository {
  Future<void> showNotification();
  Future<Notification> saveNotification();
  //NotificationDetails notificationDetails(); //어디에 넣기 애매한..
}