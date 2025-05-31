import 'package:reminder/domain/repository/item_repository.dart';
import 'package:reminder/domain/entities/item.dart';
import 'package:reminder/data/dao/item_dao.dart';
import 'package:reminder/data/model/item_model.dart';

class ItemRepositoryImpl implements ItemRepository {
  final ItemDao _itemDao;

  ItemRepositoryImpl(this._itemDao);

  @override
  Future<List<Item>> getAllItems() async {
    final itemModels = await _itemDao.getAllItems();
    return itemModels.map((model) => _mapModelToEntity(model)).toList();
  }

  @override
  Future<List<Item>> getItemsById(int itemId) async {
    final itemModel = await _itemDao.getItemById(itemId);
    return itemModel != null ? [_mapModelToEntity(itemModel)] : [];
  }

  @override
  Future<Item> saveItem(Item item) async {
    // CREATE; createdAt, updatedAt automatically set
    final now = DateTime.now();
    final nowString = _formatDateTimeToString(now);
    
    final itemWithTimestamp = Item(
      id: item.id,
      title: item.title,
      description: item.description,
      createdAt: item.createdAt ?? nowString,  // 새로 생성하는 경우 현재 시간 설정
      updatedAt: nowString,                    // 항상 현재 시간으로 업데이트
      due: item.due,
      completedAt: item.completedAt,
      flag: item.flag,
      priority: item.priority,
      repeatId: item.repeatId,
      parentId: item.parentId,
      categoryId: item.categoryId,
    );
    
    final itemModel = _mapEntityToModel(itemWithTimestamp);
    final id = await _itemDao.insertItem(itemModel);
    
    final savedModel = itemModel.copyWith(id: id);
    return _mapModelToEntity(savedModel);
  }

  @override
  Future<Item> deleteItem(int itemId) async {
    final itemModel = await _itemDao.getItemById(itemId);
    if (itemModel == null) {
      throw Exception('Item with id $itemId not found');
    }
    
    await _itemDao.deleteItem(itemId);
    return _mapModelToEntity(itemModel);
  }

  @override
  Future<Item> updateItem(Item item) async {
    // UPDATE; updatedAt automatically set
    final now = DateTime.now();
    final nowString = _formatDateTimeToString(now);
    
    // 기존 아이템 정보 가져와서 createdAt 보존
    final existingItem = await getItemById(item.id!);
    if (existingItem == null) {
      throw Exception('Item with id ${item.id} not found');
    }
    
    final itemWithTimestamp = Item(
      id: item.id,
      title: item.title,
      description: item.description,
      createdAt: existingItem.createdAt,  // 기존 createdAt 유지
      updatedAt: nowString,               // 현재 시간으로 업데이트
      due: item.due,
      completedAt: item.completedAt,
      flag: item.flag,
      priority: item.priority,
      repeatId: item.repeatId,
      parentId: item.parentId,
      categoryId: item.categoryId,
    );
    
    final itemModel = _mapEntityToModel(itemWithTimestamp);
    await _itemDao.updateItem(itemModel);
    return itemWithTimestamp;
  }

  @override
  Future<Item?> getItemById(int itemId) async {
    final itemModel = await _itemDao.getItemById(itemId);
    return itemModel != null ? _mapModelToEntity(itemModel) : null;
  }

  @override
  Future<List<Item>> getItemsByStatus(int flag) async {
    final itemModels = await _itemDao.getItemsByStatus(flag);
    return itemModels.map((model) => _mapModelToEntity(model)).toList();
  }

  @override
  Future<List<Item>> getItemsByPriority(int priority) async {
    final itemModels = await _itemDao.getItemsByPriority(priority);
    return itemModels.map((model) => _mapModelToEntity(model)).toList();
  }

  @override
  Future<List<Item>> getItemsByDateRange(String startTime, String endTime) async {
    final startMillis = _parseStringToDateTime(startTime).millisecondsSinceEpoch;
    final endMillis = _parseStringToDateTime(endTime).millisecondsSinceEpoch;
    
    final itemModels = await _itemDao.getItemsByDateRange(startMillis, endMillis);
    return itemModels.map((model) => _mapModelToEntity(model)).toList();
  }

  @override
  Future<List<Item>> getOverdueItems() async {
    final currentTime = DateTime.now().millisecondsSinceEpoch;
    final itemModels = await _itemDao.getOverdueItems(currentTime);
    return itemModels.map((model) => _mapModelToEntity(model)).toList();
  }

  @override
  Future<List<Item>> getTodayItems() async {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day).millisecondsSinceEpoch;
    final endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59).millisecondsSinceEpoch;
    
    final itemModels = await _itemDao.getTodayItems(startOfDay, endOfDay);
    return itemModels.map((model) => _mapModelToEntity(model)).toList();
  }

  @override
  Future<List<Item>> getUpcomingItems(int days) async {
    final currentTime = DateTime.now().millisecondsSinceEpoch;
    final endTime = DateTime.now().add(Duration(days: days)).millisecondsSinceEpoch;
    
    final itemModels = await _itemDao.getUpcomingItems(currentTime, endTime);
    return itemModels.map((model) => _mapModelToEntity(model)).toList();
  }

  @override
  Future<List<Item>> getCompletedItems() async {
    final itemModels = await _itemDao.getCompletedItems();
    return itemModels.map((model) => _mapModelToEntity(model)).toList();
  }

  @override
  Future<List<Item>> getItemsByCategory(int categoryId) async {
    final itemModels = await _itemDao.getItemsByCategory(categoryId);
    return itemModels.map((model) => _mapModelToEntity(model)).toList();
  }

  @override
  Future<List<Item>> getItemsByRepeat(int repeatId) async {
    final itemModels = await _itemDao.getItemsByRepeat(repeatId);
    return itemModels.map((model) => _mapModelToEntity(model)).toList();
  }

  @override
  Future<List<Item>> getSubItems(int parentId) async {
    final itemModels = await _itemDao.getSubItems(parentId);
    return itemModels.map((model) => _mapModelToEntity(model)).toList();
  }

  @override
  Future<void> markItemAsCompleted(int itemId) async {
    final now = DateTime.now();
    final completedAt = now.millisecondsSinceEpoch;
    await _itemDao.markItemAsCompleted(itemId, completedAt);
    
    final item = await getItemById(itemId);
    if (item != null) {
      final updatedItem = Item(
        id: item.id,
        title: item.title,
        description: item.description,
        createdAt: item.createdAt,
        updatedAt: _formatDateTimeToString(now),  // updatedAt 갱신
        due: item.due,
        completedAt: _formatDateTimeToString(now),
        flag: 1, // 완료 상태
        priority: item.priority,
        repeatId: item.repeatId,
        parentId: item.parentId,
        categoryId: item.categoryId,
      );
      final itemModel = _mapEntityToModel(updatedItem);
      await _itemDao.updateItem(itemModel);
    }
  }

  @override
  Future<void> markItemAsUncompleted(int itemId) async {
    await _itemDao.markItemAsUncompleted(itemId);
    
    final item = await getItemById(itemId);
    if (item != null) {
      final now = DateTime.now();
      final updatedItem = Item(
        id: item.id,
        title: item.title,
        description: item.description,
        createdAt: item.createdAt,
        updatedAt: _formatDateTimeToString(now),  // updatedAt 갱신
        due: item.due,
        completedAt: null, // 완료 시간 제거
        flag: 0, // 미완료 상태
        priority: item.priority,
        repeatId: item.repeatId,
        parentId: item.parentId,
        categoryId: item.categoryId,
      );
      final itemModel = _mapEntityToModel(updatedItem);
      await _itemDao.updateItem(itemModel);
    }
  }

  @override
  Future<List<Item>> searchItems(String query) async {
    final searchQuery = '%$query%';
    final itemModels = await _itemDao.searchItems(searchQuery);
    return itemModels.map((model) => _mapModelToEntity(model)).toList();
  }

  @override
  Future<int> getItemCount() async {
    final count = await _itemDao.getItemCount();
    return count ?? 0;
  }

  @override
  Future<int> getCompletedItemCount() async {
    final count = await _itemDao.getCompletedItemCount();
    return count ?? 0;
  }

  @override
  Future<int> getPendingItemCount() async {
    final count = await _itemDao.getPendingItemCount();
    return count ?? 0;
  }

  @override
  Future<List<Item>> getHighPriorityItems() async {
    final itemModels = await _itemDao.getHighPriorityItems();
    return itemModels.map((model) => _mapModelToEntity(model)).toList();
  }

  @override
  Future<List<Item>> getRecentItems(int limit) async {
    final itemModels = await _itemDao.getRecentItems(limit);
    return itemModels.map((model) => _mapModelToEntity(model)).toList();
  }

  @override
  Future<List<Item>> getRecentlyUpdatedItems(int limit) async {
    final itemModels = await _itemDao.getRecentlyUpdatedItems(limit);
    return itemModels.map((model) => _mapModelToEntity(model)).toList();
  }

  @override
  Future<List<Item>> getUncategorizedItems() async {
    final itemModels = await _itemDao.getUncategorizedItems();
    return itemModels.map((model) => _mapModelToEntity(model)).toList();
  }

  @override
  Future<List<Item>> getRecurringItems() async {
    final itemModels = await _itemDao.getRecurringItems();
    return itemModels.map((model) => _mapModelToEntity(model)).toList();
  }

  @override
  Future<List<Item>> getParentItems() async {
    final itemModels = await _itemDao.getParentItems();
    return itemModels.map((model) => _mapModelToEntity(model)).toList();
  }

  // Helper methods for mapping
  Item _mapModelToEntity(ItemModel model) {
    return Item(
      id: model.id,
      title: model.title,
      description: model.description,
      createdAt: model.createdAt != null 
          ? _formatMillisecondsToString(model.createdAt!)
          : null,
      updatedAt: model.updatedAt != null 
          ? _formatMillisecondsToString(model.updatedAt!)
          : null,
      due: model.due != null 
          ? _formatMillisecondsToString(model.due!)
          : null,
      completedAt: model.completedAt != null 
          ? _formatMillisecondsToString(model.completedAt!)
          : null,
      flag: model.flag,
      priority: model.priority,
      repeatId: model.repeatId,
      parentId: model.parentId,
      categoryId: model.categoryId,
    );
  }

  ItemModel _mapEntityToModel(Item entity) {
    return ItemModel(
      id: entity.id,
      title: entity.title,
      description: entity.description,
      createdAt: entity.createdAt != null 
          ? _parseStringToDateTime(entity.createdAt!).millisecondsSinceEpoch
          : null,
      updatedAt: entity.updatedAt != null 
          ? _parseStringToDateTime(entity.updatedAt!).millisecondsSinceEpoch
          : null,
      due: entity.due != null 
          ? _parseStringToDateTime(entity.due!).millisecondsSinceEpoch
          : null,
      completedAt: entity.completedAt != null 
          ? _parseStringToDateTime(entity.completedAt!).millisecondsSinceEpoch
          : null,
      flag: entity.flag,
      priority: entity.priority,
      repeatId: entity.repeatId,
      parentId: entity.parentId,
      categoryId: entity.categoryId,
    );
  }

  // helper methods for date formatting(DateTime -> str)
  String _formatDateTimeToString(DateTime dateTime) {
    return '${dateTime.year}_${dateTime.month.toString().padLeft(2, '0')}_${dateTime.day.toString().padLeft(2, '0')}_${dateTime.hour.toString().padLeft(2, '0')}_${dateTime.minute.toString().padLeft(2, '0')}';
  }

  // Helper methods for date formatting(ms -> str) and parsing
  String _formatMillisecondsToString(int milliseconds) {
    final dateTime = DateTime.fromMillisecondsSinceEpoch(milliseconds);
    return '${dateTime.year}_${dateTime.month.toString().padLeft(2, '0')}_${dateTime.day.toString().padLeft(2, '0')}_${dateTime.hour.toString().padLeft(2, '0')}_${dateTime.minute.toString().padLeft(2, '0')}';
  }

  DateTime _parseStringToDateTime(String dateString) {
    final parts = dateString.split('_');
    return DateTime(
      int.parse(parts[0]), // year
      int.parse(parts[1]), // month
      int.parse(parts[2]), // day
      int.parse(parts[3]), // hour
      int.parse(parts[4]), // minute
    );
  }
}

extension ItemModelExtension on ItemModel {
  ItemModel copyWith({
    int? id,
    String? title,
    String? description,
    int? createdAt,
    int? updatedAt,
    int? due,
    int? completedAt,
    int? flag,
    int? priority,
    int? repeatId,
    int? parentId,
    int? categoryId,
  }) {
    return ItemModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      due: due ?? this.due,
      completedAt: completedAt ?? this.completedAt,
      flag: flag ?? this.flag,
      priority: priority ?? this.priority,
      repeatId: repeatId ?? this.repeatId,
      parentId: parentId ?? this.parentId,
      categoryId: categoryId ?? this.categoryId,
    );
  }
}
