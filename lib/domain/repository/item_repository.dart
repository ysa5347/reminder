import 'package:reminder/domain/entities/item.dart';

abstract class ItemRepository {
  // 기존 메서드들
  Future<List<Item>> getAllItems();
  Future<List<Item>> getItemsById(int itemId);
  Future<Item> saveItem(Item item);
  Future<Item> deleteItem(int itemId);
  
  // Phase 1 확장 메서드들
  
  /// 아이템 수정
  Future<Item> updateItem(Item item);
  
  /// 단일 아이템 조회 (ID로)
  Future<Item?> getItemById(int itemId);
  
  /// 상태별 아이템 조회 (flag: 0=pending, 1=completed, 2=cancelled)
  Future<List<Item>> getItemsByStatus(int flag);
  
  /// 우선순위별 아이템 조회 (1=highest, 5=lowest)
  Future<List<Item>> getItemsByPriority(int priority);
  
  /// 날짜 범위별 아이템 조회 (YYYY_MM_DD_hh_mm format)
  Future<List<Item>> getItemsByDateRange(String startTime, String endTime);
  
  /// 기한 초과 아이템들 조회
  Future<List<Item>> getOverdueItems();
  
  /// 오늘 마감인 아이템들 조회
  Future<List<Item>> getTodayItems();
  
  /// 향후 N일 내 마감 아이템들 조회
  Future<List<Item>> getUpcomingItems(int days);
  
  /// 완료된 아이템들 조회
  Future<List<Item>> getCompletedItems();
  
  /// 카테고리별 아이템 조회
  Future<List<Item>> getItemsByCategory(int categoryId);
  
  /// 반복 설정별 아이템 조회
  Future<List<Item>> getItemsByRepeat(int repeatId);
  
  /// 하위 아이템들 조회 (부모 ID로)
  Future<List<Item>> getSubItems(int parentId);
  
  /// 아이템 완료 처리
  Future<void> markItemAsCompleted(int itemId);
  
  /// 아이템 미완료 처리
  Future<void> markItemAsUncompleted(int itemId);
  
  /// 아이템 검색 (제목, 설명에서)
  Future<List<Item>> searchItems(String query);
  
  /// 전체 아이템 개수
  Future<int> getItemCount();
  
  /// 완료된 아이템 개수
  Future<int> getCompletedItemCount();
  
  /// 대기 중인 아이템 개수
  Future<int> getPendingItemCount();
  
  /// 우선순위 높은 아이템들 조회 (urgent items)
  Future<List<Item>> getHighPriorityItems();
  
  /// 최근 생성된 아이템들 조회
  Future<List<Item>> getRecentItems(int limit);
  
  /// 최근 수정된 아이템들 조회
  Future<List<Item>> getRecentlyUpdatedItems(int limit);
  
  /// 카테고리가 없는 아이템들 조회
  Future<List<Item>> getUncategorizedItems();
  
  /// 반복 설정이 있는 아이템들 조회
  Future<List<Item>> getRecurringItems();
  
  /// 하위 아이템이 있는 부모 아이템들 조회
  Future<List<Item>> getParentItems();
}
