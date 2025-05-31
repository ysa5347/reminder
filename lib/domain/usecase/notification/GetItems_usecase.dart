import 'package:reminder/domain/entities/notification_entities.dart';
import 'package:reminder/domain/repository/notification_repository.dart';

class GetItemsUsecase {
  final NotificationRepository repository;

  GetItemsUsecase({required this.repository});

  Future<List<Item>> execute(int itemId) async {
    return await repository.GetItemsById(itemId);
  }
}