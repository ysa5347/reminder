import '../../../domain/entities/category.dart';
import '../../../domain/repository/category_repository.dart';

class SaveCategoryUsecase {
  final CategoryRepository repository;

  SaveCategoryUsecase({required this.repository});

  Future<Category> call(Category category) async {
    print('SaveCategoryUsecase: Saving category: ${category.name}');
    try {
      final result = await repository.saveCategory(category);
      print('SaveCategoryUsecase: Category saved with ID: ${result.id}');
      return result;
    } catch (error) {
      print('SaveCategoryUsecase: Error: $error');
      rethrow;
    }
  }
}
