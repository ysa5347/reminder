import 'package:reminder/domain/repository/notification_repository.dart';
import 'package:reminder/domain/entities/notification_entities.dart';

class GetNotificationsUsecase {
  final NotificationRepository repository;

  GetNotificationsUsecase({required this.repository});

  Future<List<Notification>> execute(int notificationId) async {
    return await repository.GetNotificationsById(notificationId);
  }
}