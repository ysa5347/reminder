import 'package:reminder/domain/entities/notification_entities.dart';
import 'package:reminder/domain/repository/notification_repository.dart';

class SaveNotificationUsecase {
  final NotificationRepository repository;

  SaveNotificationUsecase({required this.repository});

  Future<Notification> execute(Notification notification) async {
    return await repository.saveNotification(notification);
  }
}
