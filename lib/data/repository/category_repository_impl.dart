import 'package:reminder/domain/repository/category_repository.dart';
import 'package:reminder/domain/entities/category.dart';
import 'package:reminder/domain/entities/item.dart';
import 'package:reminder/data/dao/category_dao.dart';
import 'package:reminder/data/dao/item_dao.dart';
import 'package:reminder/data/model/category_model.dart';
import 'package:reminder/data/model/item_model.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final CategoryDao _categoryDao;
  final ItemDao _itemDao;

  CategoryRepositoryImpl(this._categoryDao, this._itemDao);

  @override
  Future<List<Category>> getAllCategories() async {
    final categoryModels = await _categoryDao.getAllCategories();
    return categoryModels.map((model) => _mapModelToEntity(model)).toList();
  }

  @override
  Future<Category?> getCategoryById(int id) async {
    final categoryModel = await _categoryDao.getCategoryById(id);
    return categoryModel != null ? _mapModelToEntity(categoryModel) : null;
  }

  @override
  Future<Category> saveCategory(Category category) async {
    final categoryModel = _mapEntityToModel(category);
    final id = await _categoryDao.insertCategory(categoryModel);
    
    final savedModel = categoryModel.copyWith(id: id);
    return _mapModelToEntity(savedModel);
  }

  @override
  Future<Category> updateCategory(Category category) async {
    final categoryModel = _mapEntityToModel(category);
    await _categoryDao.updateCategory(categoryModel);
    return category;
  }

  @override
  Future<void> deleteCategory(int id) async {
    await _categoryDao.deleteCategory(id);
  }

  @override
  Future<List<Item>> getItemsByCategory(int categoryId) async {
    final itemModels = await _itemDao.getItemsByCategory(categoryId);
    return itemModels.map((model) => _mapItemModelToEntity(model)).toList();
  }

  @override
  Future<int> getItemCountByCategory(int categoryId) async {
    final count = await _categoryDao.getItemCountByCategory(categoryId);
    return count ?? 0;
  }

  @override
  Future<List<Category>> searchCategoriesByName(String name) async {
    final categoryModels = await _categoryDao.getCategoriesByName('%$name%');
    return categoryModels.map((model) => _mapModelToEntity(model)).toList();
  }

  @override
  Future<Category> createDefaultCategory() async {
    final defaultCategory = Category(
      name: 'Default',
      description: 'Default category for uncategorized items',
      color: '#2196F3',
      icon: 'folder',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    return await saveCategory(defaultCategory);
  }

  @override
  Future<bool> isCategoryInUse(int categoryId) async {
    final count = await _categoryDao.checkCategoryUsage(categoryId);
    return (count ?? 0) > 0;
  }

  // Helper methods for mapping
  Category _mapModelToEntity(CategoryModel model) {
    return Category(
      id: model.id,
      name: model.title,
      description: model.description,
      color: model.color,
      icon: model.icon,
      createdAt: model.createdAt != null 
          ? DateTime.fromMillisecondsSinceEpoch(model.createdAt!)
          : null,
      updatedAt: model.updatedAt != null 
          ? DateTime.fromMillisecondsSinceEpoch(model.updatedAt!)
          : null,
    );
  }

  CategoryModel _mapEntityToModel(Category entity) {
    return CategoryModel(
      id: entity.id,
      title: entity.name,
      description: entity.description,
      color: entity.color,
      icon: entity.icon,
      createdAt: entity.createdAt?.millisecondsSinceEpoch,
      updatedAt: entity.updatedAt?.millisecondsSinceEpoch,
    );
  }

  Item _mapItemModelToEntity(ItemModel model) {
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

  String _formatMillisecondsToString(int milliseconds) {
    final dateTime = DateTime.fromMillisecondsSinceEpoch(milliseconds);
    return '${dateTime.year}_${dateTime.month.toString().padLeft(2, '0')}_${dateTime.day.toString().padLeft(2, '0')}_${dateTime.hour.toString().padLeft(2, '0')}_${dateTime.minute.toString().padLeft(2, '0')}';
  }
}

extension CategoryModelExtension on CategoryModel {
  CategoryModel copyWith({
    int? id,
    String? title,
    String? description,
    String? color,
    String? icon,
    int? createdAt,
    int? updatedAt,
  }) {
    return CategoryModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      color: color ?? this.color,
      icon: icon ?? this.icon,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
