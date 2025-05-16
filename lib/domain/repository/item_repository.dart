import '../entities/item.dart';

abstract class ItemRepository {
  Future<List<Item>> getAllItems();
  Future<List<Item>> getItemsByDue(DateTime due);
  Future<List<Item>> getItemsByCategory(int categoryId);
  Future<Item?> getItemById(int id);
  Future<int> createItem(Item item);
  Future<int> updateItem(Item item);
  Future<int> deleteItem(int id);
  Future<List<Item>> getUpcomingReminders(int limit);
  Future<List<Item>> getCompletedItems();
  // Future<List<Item>> getItemsByTag(String tag);
}