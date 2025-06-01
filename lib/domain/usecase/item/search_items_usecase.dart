import 'package:reminder/domain/entities/item.dart';
import 'package:reminder/domain/repository/item_repository.dart';

class SearchItemsUsecase {
  final ItemRepository repository;

  SearchItemsUsecase({required this.repository});

  Future<List<Item>> execute(String query) async {
    if (query.trim().isEmpty) {
      return [];
    }
    return await repository.searchItems(query);
  }
}
