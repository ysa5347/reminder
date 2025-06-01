import 'package:reminder/domain/entities/item.dart';
import 'package:reminder/domain/repository/item_repository.dart';

class SaveItemUsecase {
  final ItemRepository repository;

  SaveItemUsecase({required this.repository});

  Future<Item> execute(Item item) async {
    return await repository.saveItem(item);
  }
}