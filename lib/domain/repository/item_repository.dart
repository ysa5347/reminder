import 'package:reminder/domain/entities/item.dart';

abstract class ItemRepository {
  Future<List<Item>> getAllItems();
  Future<List<Item>> GetItemsById(int itemId);
  Future<Item> SaveItem(Item item);
  Future<Item> DeleteItem(int itemId);
}
