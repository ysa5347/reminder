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

  @Query('SELECT * FROM items WHERE flag = :flag')
  Future<List<ItemModel>> getItemsByStatus(int flag);

  @Query('SELECT * FROM items WHERE priority = :priority')
  Future<List<ItemModel>> getItemsByPriority(int priority);

  @Query('SELECT * FROM items WHERE due >= :startTime AND due <= :endTime')
  Future<List<ItemModel>> getItemsByDateRange(int startTime, int endTime);

  @Query('SELECT * FROM items WHERE due < :currentTime AND flag != 1')
  Future<List<ItemModel>> getOverdueItems(int currentTime);

  @Query('SELECT * FROM items WHERE due >= :startOfDay AND due <= :endOfDay')
  Future<List<ItemModel>> getTodayItems(int startOfDay, int endOfDay);

  @Query('SELECT * FROM items WHERE due >= :currentTime AND due <= :endTime AND flag != 1 ORDER BY due ASC')
  Future<List<ItemModel>> getUpcomingItems(int currentTime, int endTime);

  @Query('SELECT * FROM items WHERE flag = 1')
  Future<List<ItemModel>> getCompletedItems();

  @Query('SELECT * FROM items WHERE repeat_id = :repeatId')
  Future<List<ItemModel>> getItemsByRepeat(int repeatId);

  @Query('SELECT * FROM items WHERE parent_id = :parentId')
  Future<List<ItemModel>> getSubItems(int parentId);

  @Query('SELECT * FROM items WHERE (title LIKE :query OR description LIKE :query)')
  Future<List<ItemModel>> searchItems(String query);

  @Query('SELECT COUNT(*) FROM items')
  Future<int?> getItemCount();

  @Query('SELECT COUNT(*) FROM items WHERE flag = 1')
  Future<int?> getCompletedItemCount();

  @Query('SELECT COUNT(*) FROM items WHERE flag = 0')
  Future<int?> getPendingItemCount();

  @Query('SELECT * FROM items WHERE priority <= 2 AND flag != 1 ORDER BY priority ASC, due ASC')
  Future<List<ItemModel>> getHighPriorityItems();

  @Query('SELECT * FROM items ORDER BY created_at DESC LIMIT :limit')
  Future<List<ItemModel>> getRecentItems(int limit);

  @Query('SELECT * FROM items ORDER BY updated_at DESC LIMIT :limit')
  Future<List<ItemModel>> getRecentlyUpdatedItems(int limit);

  @Query('SELECT * FROM items WHERE category_id IS NULL')
  Future<List<ItemModel>> getUncategorizedItems();

  @Query('SELECT * FROM items WHERE repeat_id IS NOT NULL')
  Future<List<ItemModel>> getRecurringItems();

  @Query('SELECT DISTINCT parent.* FROM items parent WHERE EXISTS (SELECT 1 FROM items child WHERE child.parent_id = parent.id)')
  Future<List<ItemModel>> getParentItems();

  @insert
  Future<int> insertItem(ItemModel item);

  @update
  Future<int> updateItem(ItemModel item);

  @Query('UPDATE items SET flag = 1, completed_at = :completedAt WHERE id = :id')
  Future<int?> markItemAsCompleted(int id, int completedAt);

  @Query('UPDATE items SET flag = 0, completed_at = NULL WHERE id = :id')
  Future<int?> markItemAsUncompleted(int id);

  @Query('DELETE FROM items WHERE id = :id')
  Future<int?> deleteItem(int id);
}
