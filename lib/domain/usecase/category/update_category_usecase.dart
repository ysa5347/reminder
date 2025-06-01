import '../../../domain/entities/category.dart';
import '../../../domain/repository/category_repository.dart';

class UpdateCategoryUsecase {
  final CategoryRepository repository;

  UpdateCategoryUsecase({required this.repository});

  Future<Category> call(Category category) async {
    return await repository.updateCategory(category);
  }
}
