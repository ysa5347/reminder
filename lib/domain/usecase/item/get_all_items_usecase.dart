import '../../entities/item.dart';
import '../../repository/item_repository.dart';

class GetAllItemsUsecase {
  final ItemRepository itemRepository;

  GetAllItemsUsecase(this.itemRepository);

  Future<List<Item>> execute() async {
    return await itemRepository.getAllItems();
  }
}

