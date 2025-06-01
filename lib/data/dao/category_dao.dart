import 'package:floor/floor.dart';
import '../model/category_model.dart';

@dao
abstract class CategoryDao {
  @Query('SELECT * FROM categories')
  Future<List<CategoryModel>> getAllCategories();

  @Query('SELECT * FROM categories WHERE id = :id')
  Future<CategoryModel?> getCategoryById(int id);

  @Query('SELECT * FROM categories WHERE title LIKE :name')
  Future<List<CategoryModel>> getCategoriesByName(String name);

  @Query('SELECT COUNT(*) FROM items WHERE category_id = :categoryId')
  Future<int?> getItemCountByCategory(int categoryId);

  @insert
  Future<int> insertCategory(CategoryModel category);

  @update
  Future<int> updateCategory(CategoryModel category);

  @Query('DELETE FROM categories WHERE id = :id')
  Future<int?> deleteCategory(int id);

  @Query('SELECT COUNT(*) FROM items WHERE category_id = :categoryId')
  Future<int?> checkCategoryUsage(int categoryId);
}
