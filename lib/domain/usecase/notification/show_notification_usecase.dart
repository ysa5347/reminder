import 'package:reminder/domain/repository/notification_repository.dart';
import 'package:reminder/domain/entities/notification_entities.dart';

class ShowNotificationUsecase {
  final NotificationRepository repository;

  ShowNotificationUsecase({required this.repository});

  Future<void> excute() async {
    return await repository.showNotification();
  }
}