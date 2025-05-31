import 'package:reminder/domain/repository/notification_repository.dart';
import 'package:reminder/domain/entities/notification_entities.dart';
import 'package:reminder/data/dao/notification_dao.dart';
import 'package:reminder/data/model/notification_model.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationDao _notificationDao;

  NotificationRepositoryImpl(this._notificationDao);

  @override
  Future<List<Notification>> getNotificationsById(int notificationId) async {
    final notificationModel = await _notificationDao.getNotificationById(notificationId);
    return notificationModel != null ? [_mapModelToEntity(notificationModel)] : [];
  }

  @override
  Future<List<Notification>> getNotificationsByTitle(String notificationTitle) async {
    // Note: This method searches by title but NotificationModel doesn't have a title field
    // We need to join with ItemModel to search by item title
    // For now, returning empty list - this would need to be implemented with a proper join query
    return [];
  }

  @override
  Future<Notification> saveNotification(Notification notification) async {
    final notificationModel = _mapEntityToModel(notification);
    final id = await _notificationDao.insertNotification(notificationModel);
    
    final savedModel = notificationModel.copyWith(id: id);
    return _mapModelToEntity(savedModel);
  }

  @override
  Future<Notification> deleteNotification(int notificationId) async {
    final notificationModel = await _notificationDao.getNotificationById(notificationId);
    if (notificationModel == null) {
      throw Exception('Notification with id $notificationId not found');
    }
    
    await _notificationDao.deleteNotification(notificationId);
    return _mapModelToEntity(notificationModel);
  }

  // Additional methods for comprehensive notification management
  Future<List<Notification>> getAllNotifications() async {
    final notificationModels = await _notificationDao.getAllNotifications();
    return notificationModels.map((model) => _mapModelToEntity(model)).toList();
  }

  Future<List<Notification>> getNotificationsByItemId(int itemId) async {
    final notificationModels = await _notificationDao.getNotificationsByItemId(itemId);
    return notificationModels.map((model) => _mapModelToEntity(model)).toList();
  }

  Future<List<Notification>> getNotificationsByTimeRange(String startTime, String endTime) async {
    final startMillis = _parseStringToDateTime(startTime).millisecondsSinceEpoch;
    final endMillis = _parseStringToDateTime(endTime).millisecondsSinceEpoch;
    
    final notificationModels = await _notificationDao.getNotificationsByTimeRange(startMillis, endMillis);
    return notificationModels.map((model) => _mapModelToEntity(model)).toList();
  }

  Future<List<Notification>> getOverdueNotifications() async {
    final currentTime = DateTime.now().millisecondsSinceEpoch;
    final notificationModels = await _notificationDao.getOverdueNotifications(currentTime);
    return notificationModels.map((model) => _mapModelToEntity(model)).toList();
  }

  Future<List<Notification>> getNotificationsByPriority(int priority) async {
    final notificationModels = await _notificationDao.getNotificationsByPriority(priority);
    return notificationModels.map((model) => _mapModelToEntity(model)).toList();
  }

  Future<List<Notification>> getNotificationsByQueue(int queue) async {
    final notificationModels = await _notificationDao.getNotificationsByQueue(queue);
    return notificationModels.map((model) => _mapModelToEntity(model)).toList();
  }

  Future<Notification> updateNotification(Notification notification) async {
    final notificationModel = _mapEntityToModel(notification);
    await _notificationDao.updateNotification(notificationModel);
    return notification;
  }

  Future<void> deleteNotificationsByItemId(int itemId) async {
    await _notificationDao.deleteNotificationsByItemId(itemId);
  }

  Future<int> getNotificationCount() async {
    final count = await _notificationDao.getNotificationCount();
    return count ?? 0;
  }

  // Helper methods for mapping
  Notification _mapModelToEntity(NotificationModel model) {
    // Since NotificationModel and Notification entity have different structures,
    // we need to adapt the mapping based on available fields
    return Notification(
      notificationId: model.id ?? 0,
      timeValue: model.time != null 
          ? _formatMillisecondsToString(model.time!)
          : _formatMillisecondsToString(DateTime.now().millisecondsSinceEpoch),
      title: 'Notification ${model.id}', // Default title since model doesn't have title
      description: 'Priority: ${model.priority}, Queue: ${model.queue}',
    );
  }

  NotificationModel _mapEntityToModel(Notification entity) {
    return NotificationModel(
      id: entity.notificationId != 0 ? entity.notificationId : null,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      itemId: null, // This would need to be provided from context
      time: _parseStringToDateTime(entity.timeValue).millisecondsSinceEpoch,
      priority: 3, // Default priority
      queue: 1, // Default queue
    );
  }

  // Helper methods for date formatting and parsing
  String _formatMillisecondsToString(int milliseconds) {
    final dateTime = DateTime.fromMillisecondsSinceEpoch(milliseconds);
    return '${dateTime.year}_${dateTime.month.toString().padLeft(2, '0')}_${dateTime.day.toString().padLeft(2, '0')}_${dateTime.hour.toString().padLeft(2, '0')}_${dateTime.minute.toString().padLeft(2, '0')}';
  }

  DateTime _parseStringToDateTime(String dateString) {
    final parts = dateString.split('_');
    return DateTime(
      int.parse(parts[0]), // year
      int.parse(parts[1]), // month
      int.parse(parts[2]), // day
      int.parse(parts[3]), // hour
      int.parse(parts[4]), // minute
    );
  }
}

extension NotificationModelExtension on NotificationModel {
  NotificationModel copyWith({
    int? id,
    int? createdAt,
    int? itemId,
    int? time,
    int? priority,
    int? queue,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      itemId: itemId ?? this.itemId,
      time: time ?? this.time,
      priority: priority ?? this.priority,
      queue: queue ?? this.queue,
    );
  }
}
