import 'package:reminder/domain/entities/notification_entities.dart';

abstract class NotificationRepository {
  Future<List<Notification>> GetNotificationsById(int notificationId);  //get Notification entity from database by notificationId
  Future<List<Notification>> GetNotificationsByTitle(String notificationTitle); //get Notification entity from database by Notification.Title
  Future<Notification> SaveNotification(Notification notification); //save Notification entity to database
  Future<Notification> DeleteNotification(int notificationId); //delete Notification entity from database by notificationId
}