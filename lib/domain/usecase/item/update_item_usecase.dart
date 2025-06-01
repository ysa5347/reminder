import 'package:reminder/domain/entities/item.dart';
import 'package:reminder/domain/repository/item_repository.dart';

class UpdateItemUsecase {
  final ItemRepository repository;

  UpdateItemUsecase({required this.repository});

  Future<Item> execute(Item item) async {
    return await repository.updateItem(item);
  }
}
