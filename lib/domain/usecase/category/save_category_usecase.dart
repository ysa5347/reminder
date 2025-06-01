import '../../../domain/entities/category.dart';
import '../../../domain/repository/category_repository.dart';

class SaveCategoryUsecase {
  final CategoryRepository repository;

  SaveCategoryUsecase({required this.repository});

  Future<Category> call(Category category) async {
    return await repository.saveCategory(category);
  }
}
