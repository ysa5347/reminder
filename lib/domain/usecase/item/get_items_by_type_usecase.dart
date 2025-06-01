import 'package:reminder/domain/entities/item.dart';
import 'package:reminder/domain/repository/item_repository.dart';

class GetItemsByTypeUsecase {
  final ItemRepository repository;

  GetItemsByTypeUsecase({required this.repository});

  Future<List<Item>> execute(String type, {int? categoryId}) async {
    switch (type) {
      case 'today':
        return await repository.getTodayItems();
      case 'incomplete':
        return await repository.getItemsByStatus(0); // flag: 0 = pending
      case 'flagged':
        return await repository.getHighPriorityItems();
      case 'highPriority':
        return await repository.getItemsByPriority(1); // priority 1 = highest
      case 'category':
        if (categoryId != null) {
          return await repository.getItemsByCategory(categoryId);
        }
        return [];
      case 'search':
        return await repository.getAllItems(); // 검색 결과는 별도 처리
      default:
        return await repository.getAllItems();
    }
  }
}
