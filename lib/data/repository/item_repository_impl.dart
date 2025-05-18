import '../../domain/entities/item.dart';
import '../../domain/repository/item_repository.dart';
import '../dao/item_dao.dart';
import '../model/item_model.dart';

class ItemRepositoryImpl implements ItemRepository{
  final ItemDao _itemDao;

  ItemRepositoryImpl(this._itemDao);

  @override
  Future<List<Item>> getAllItems() async{
    final models = await _itemDao.getAllItems();
    return models.map((model) => model.toEntity()).toList();
  }
  @override
  Future<List<Item>> getItemsByDue(DateTime due) async {
    final startOfDay = DateTime(due.year, due.month, due.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));
    
    final models = await _itemDao.getItemsByDue(
      startOfDay.millisecondsSinceEpoch,
      endOfDay.millisecondsSinceEpoch,
    );

    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<List<Item>> getItemsByCategory(int categoryId) async {
    final models = await _itemDao.getItemsByCategory(categoryId);
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<Item?> getItemById(int id) async {
    final model = await _itemDao.getItemById(id);
    return model?.toEntity();
  }

  @override
  Future<int> createItem(Item item) async {
    final model = ItemModel.fromEntity(item);
    return await _itemDao.createItem(model);
  }
  @override
  Future<int> updateItem(Item item) async {
    final model = ItemModel.fromEntity(item);
    return await _itemDao.updateItem(model);
  }
  
  @override
  Future<int?> deleteItem(int id) async {
    return await _itemDao.deleteItem(id);
  }

  @override
  Future<List<Item>> getUpcomingReminders(int limit) async {
    final now = DateTime.now().millisecondsSinceEpoch;
    final models = await _itemDao.getUpcomingItems(now, limit);
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<List<Item>> getCompletedItems() async {
    final models = await _itemDao.getCompletedItems();
    return models.map((model) => model.toEntity()).toList();
  }

  // @override
  // Future<List<Item>> getItemsByTag(String tag) async {
  //   final models = await _itemDao.getItemsByTag(tag);

  // }

}