import 'package:reminder/domain/entities/item.dart';
import 'package:reminder/domain/repository/item_repository.dart';

class GetItemsUsecase {
  final ItemRepository repository;

  GetItemsUsecase({required this.repository});

  Future<List<Item>> execute(int itemId) async {
    return await repository.GetItemsById(itemId);
  }
}