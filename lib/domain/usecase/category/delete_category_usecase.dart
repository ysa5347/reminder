import '../../../domain/repository/category_repository.dart';

class DeleteCategoryUsecase {
  final CategoryRepository repository;

  DeleteCategoryUsecase({required this.repository});

  Future<void> call(int categoryId) async {
    // 카테고리가 사용 중인지 확인
    final isInUse = await repository.isCategoryInUse(categoryId);
    if (isInUse) {
      throw Exception('카테고리가 사용 중이므로 삭제할 수 없습니다.');
    }
    
    return await repository.deleteCategory(categoryId);
  }
}
