import '../../entities/item.dart';
import '../../repository/item_repository.dart';

class GetMostUrgentPendingItemUsecase {
  final ItemRepository repository;

  GetMostUrgentPendingItemUsecase(this.repository);

  Future<Item?> execute({int withinDays = 7}) async {
    // 1. 가까운 며칠 안에 마감되는 모든 항목 가져오기
    final upcomingItems = await repository.getUpcomingItems(withinDays);

    // 2. 완료되지 않았고 flag == 0 (pending)인 항목 필터링
    final pendingItems = upcomingItems.where((item) =>
      item.flag == 0 && item.due != null && _parseDate(item.due!).isAfter(DateTime.now())
    ).toList();

    // 3. due 기준으로 정렬 (가장 임박한 순)
    pendingItems.sort((a, b) =>
      _parseDate(a.due!).compareTo(_parseDate(b.due!)));

    // 4. 가장 위에 있는 항목 반환 (없으면 null)
    return pendingItems.isNotEmpty ? pendingItems.first : null;
  }

  DateTime _parseDate(String dateString) {
    final parts = dateString.split('_').map(int.parse).toList();
    return DateTime(parts[0], parts[1], parts[2], parts[3], parts[4]);
  }
}
