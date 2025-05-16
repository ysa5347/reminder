import 'package:reminder/domain/entities/notification_entities.dart';
import 'package:reminder/domain/repository/notification_repository.dart';

class SaveNotificationUsecase {
  final NotificationRepository repository;
  SaveNotificationUsecase({required this.repository});

  Future<Notification> excute(String timeValue, String title) async{
    return await repository.saveNotification(timeValue, title);
  }
}
