import 'package:reminder/domain/entities/item.dart';
import 'package:reminder/domain/repository/item_repository.dart';

class DeleteItemUsecase {
  final ItemRepository repository;

  DeleteItemUsecase({required this.repository});

  Future<Item> execute(int itemId) async {
    return await repository.deleteItem(itemId);
  }
}
