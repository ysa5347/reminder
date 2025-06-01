import 'package:floor/floor.dart';
import '../model/notification_model.dart';

@dao
abstract class NotificationDao {
  @Query('SELECT * FROM notifications')
  Future<List<NotificationModel>> getAllNotifications();

  @Query('SELECT * FROM notifications WHERE id = :id')
  Future<NotificationModel?> getNotificationById(int id);

  @Query('SELECT * FROM notifications WHERE item_id = :itemId')
  Future<List<NotificationModel>> getNotificationsByItemId(int itemId);

  @Query('SELECT * FROM notifications WHERE time >= :startTime AND time <= :endTime')
  Future<List<NotificationModel>> getNotificationsByTimeRange(int startTime, int endTime);

  @Query('SELECT * FROM notifications WHERE time <= :currentTime ORDER BY time ASC')
  Future<List<NotificationModel>> getOverdueNotifications(int currentTime);

  @Query('SELECT * FROM notifications WHERE priority = :priority')
  Future<List<NotificationModel>> getNotificationsByPriority(int priority);

  @Query('SELECT * FROM notifications WHERE queue = :queue')
  Future<List<NotificationModel>> getNotificationsByQueue(int queue);

  @insert
  Future<int> insertNotification(NotificationModel notification);

  @update
  Future<int> updateNotification(NotificationModel notification);

  @Query('DELETE FROM notifications WHERE id = :id')
  Future<int?> deleteNotification(int id);

  @Query('DELETE FROM notifications WHERE item_id = :itemId')
  Future<int?> deleteNotificationsByItemId(int itemId);

  @Query('SELECT COUNT(*) FROM notifications')
  Future<int?> getNotificationCount();
}
