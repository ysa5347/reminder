import 'package:reminder/domain/entities/notification_entities.dart';

abstract class NotificationRepository {
  Future<List<Notification>> GetNotificationsById(int notificationId);  //get Notification entity from database by notificationId
  Future<List<Notification>> GetNotificationsByTitle(String notificationTitle); //get Notification entity from database by Notification.Title

  Future<List<Item>> GetItemsById(int itemId); //get Item entity from database by itemId
  Future<Item> SaveItem(Item item); //save Item entity to database
  Future<Item> DeleteItem(int itemId); //delete Item entity from database by itemId
  Future<Notification> SaveNotification(Notification notification); //save Notification entity to database
  Future<Notification> DeleteNotification(int notificationId); //delete Notification entity from database by notificationId
}