import 'package:floor/floor.dart';
import '../model/item_model.dart';

@dao
abstract class ItemDao {
  @Query('SELECT * FROM items')
  Future<List<ItemModel>> getAllItems();

  @Query('SELECT * FROM items WHERE id = :id')
  Future<ItemModel?> getItemById(int id);

  @Query('SELECT * FROM items WHERE category_id = :categoryId')
  Future<List<ItemModel>> getItemsByCategory(int categoryId);

  @Query('SELECT * FROM items WHERE due >= :startOfDay AND due <= :endOfDay')
  Future<List<ItemModel>> getItemsByDue(int startOfDay, int endOfDay); 

  @insert
  Future<int> createItem(ItemModel item);
  @update
  Future<int> updateItem(ItemModel item);

  @Query('DELETE FROM items WHERE id = :id')
  Future<int?> deleteItem(int id);

  @Query('SELECT * FROM items WHERE due > :now ORDER BY due ASC LIMIT :limit')
  Future<List<ItemModel>> getUpcomingItems(int now, int limit);

  @Query('SELECT * FROM items WHERE is_completed = 1')
  Future<List<ItemModel>> getCompletedItems();
}

