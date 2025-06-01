import 'package:reminder/domain/entities/notification_entities.dart';

abstract class NotificationRepository {
  /// Get notification entity from database by notificationId
  Future<List<Notification>> getNotificationsById(int notificationId);
  
  /// Get notification entity from database by notification title
  Future<List<Notification>> getNotificationsByTitle(String notificationTitle);
  
  /// Save notification entity to database
  Future<Notification> saveNotification(Notification notification);
  
  /// Delete notification entity from database by notificationId
  Future<Notification> deleteNotification(int notificationId);
}