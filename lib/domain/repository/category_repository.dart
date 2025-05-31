import 'package:reminder/domain/entities/category.dart';
import 'package:reminder/domain/entities/item.dart';

abstract class CategoryRepository {
  /// 모든 카테고리 조회
  Future<List<Category>> getAllCategories();
  
  /// ID로 카테고리 조회
  Future<Category?> getCategoryById(int id);
  
  /// 카테고리 저장 (생성/수정)
  Future<Category> saveCategory(Category category);
  
  /// 카테고리 수정
  Future<Category> updateCategory(Category category);
  
  /// 카테고리 삭제
  Future<void> deleteCategory(int id);
  
  /// 특정 카테고리에 속한 아이템들 조회
  Future<List<Item>> getItemsByCategory(int categoryId);
  
  /// 특정 카테고리의 아이템 개수 조회
  Future<int> getItemCountByCategory(int categoryId);
  
  /// 카테고리 이름으로 검색
  Future<List<Category>> searchCategoriesByName(String name);
  
  /// 기본 카테고리 생성
  Future<Category> createDefaultCategory();
  
  /// 카테고리 사용 여부 확인 (삭제 전 체크용)
  Future<bool> isCategoryInUse(int categoryId);
}
