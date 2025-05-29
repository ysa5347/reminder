import 'package:reminder/domain/entities/notification_entities.dart';
import 'package:reminder/domain/repository/notification_repository.dart';

class SaveItemUsecase {
  final NotificationRepository repository;

  SaveItemUsecase({required this.repository});

  Future<Item> execute(Item item) async {
    return await repository.SaveItem(item);
  }
}