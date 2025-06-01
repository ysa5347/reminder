import '../../../domain/entities/category.dart';
import '../../../domain/repository/category_repository.dart';

class GetCategoriesUsecase {
  final CategoryRepository repository;

  GetCategoriesUsecase({required this.repository});

  Future<List<Category>> call() async {
    return await repository.getAllCategories();
  }
}
