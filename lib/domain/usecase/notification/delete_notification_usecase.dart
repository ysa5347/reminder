import 'package:reminder/domain/entities/notification_entities.dart';
import 'package:reminder/domain/repository/notification_repository.dart';

class DeleteNotificationUsecase {
  final NotificationRepository repository;

  DeleteNotificationUsecase({required this.repository});

  Future<Notification> execute(int notificationId) async {
    return await repository.deleteNotification(notificationId);
  }
}
