import 'package:reminder/domain/entities/notification_entities.dart';
import 'package:reminder/domain/repository/notification_repository.dart';

class GetNotificationsUsecase {
  final NotificationRepository repository;

  GetNotificationsUsecase({required this.repository});

  Future<List<Notification>> execute(int notificationId) async {
    return await repository.getNotificationsById(notificationId);
  }
}