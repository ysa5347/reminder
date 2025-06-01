import 'package:flutter_bloc/flutter_bloc.dart';
import 'item_list_event.dart';
import 'item_list_state.dart';
import '../../../domain/usecase/item/get_items_by_type_usecase.dart';
import '../../../domain/usecase/item/search_items_usecase.dart';
import '../../../domain/usecase/item/SaveItem_usecase.dart';
import '../../../domain/usecase/item/update_item_usecase.dart';
import '../../../domain/usecase/item/delete_item_usecase.dart';
import '../../../domain/usecase/notification/save_notification_usecase.dart';
import '../../../domain/usecase/notification/delete_notification_usecase.dart';
import '../../../domain/usecase/Alarm/SetAlarm_usecase.dart';
import '../../../domain/usecase/Alarm/DeleteAlarm_usecase.dart';
import '../../../domain/entities/item.dart';
import '../../../domain/entities/notification_entities.dart';

class ItemListBloc extends Bloc<ItemListEvent, ItemListState> {
  final GetItemsByTypeUsecase _getItemsByTypeUsecase;
  final SearchItemsUsecase _searchItemsUsecase;
  final SaveItemUsecase _saveItemUsecase;
  final UpdateItemUsecase _updateItemUsecase;
  final DeleteItemUsecase _deleteItemUsecase;
  final SaveNotificationUsecase _saveNotificationUsecase;
  final DeleteNotificationUsecase _deleteNotificationUsecase;
  final SetAlarmUsecase _setAlarmUsecase;
  final DeleteAlarmUsecase _deleteAlarmUsecase;

  ItemListBloc({
    required GetItemsByTypeUsecase getItemsByTypeUsecase,
    required SearchItemsUsecase searchItemsUsecase,
    required SaveItemUsecase saveItemUsecase,
    required UpdateItemUsecase updateItemUsecase,
    required DeleteItemUsecase deleteItemUsecase,
    required SaveNotificationUsecase saveNotificationUsecase,
    required DeleteNotificationUsecase deleteNotificationUsecase,
    required SetAlarmUsecase setAlarmUsecase,
    required DeleteAlarmUsecase deleteAlarmUsecase,
  })  : _getItemsByTypeUsecase = getItemsByTypeUsecase,
        _searchItemsUsecase = searchItemsUsecase,
        _saveItemUsecase = saveItemUsecase,
        _updateItemUsecase = updateItemUsecase,
        _deleteItemUsecase = deleteItemUsecase,
        _saveNotificationUsecase = saveNotificationUsecase,
        _deleteNotificationUsecase = deleteNotificationUsecase,
        _setAlarmUsecase = setAlarmUsecase,
        _deleteAlarmUsecase = deleteAlarmUsecase,
        super(const ItemListInitial()) {
    on<LoadItemsByType>(_onLoadItemsByType);
    on<SearchItemsEvent>(_onSearchItems);
    on<AddNewItem>(_onAddNewItem);
    on<UpdateItemTitle>(_onUpdateItemTitle);
    on<UpdateItemEvent>(_onUpdateItem);
    on<DeleteItemEvent>(_onDeleteItem);
    on<ToggleItemCompletion>(_onToggleItemCompletion);
    on<RefreshItemList>(_onRefreshItemList);
  }

  Future<void> _onLoadItemsByType(LoadItemsByType event, Emitter<ItemListState> emit) async {
    try {
      emit(const ItemListLoading());
      
      final items = await _getItemsByTypeUsecase.execute(event.type, categoryId: event.categoryId);
      
      String title = _getPageTitle(event.type, event.categoryName);
      
      emit(ItemListLoaded(
        items: items,
        type: event.type,
        title: title,
      ));
    } catch (e) {
      emit(ItemListError('Failed to load items: ${e.toString()}'));
    }
  }

  Future<void> _onSearchItems(SearchItemsEvent event, Emitter<ItemListState> emit) async {
    try {
      emit(const ItemListLoading());
      
      final items = await _searchItemsUsecase.execute(event.query);
      
      emit(ItemListLoaded(
        items: items,
        type: 'search',
        title: '검색 결과',
        searchQuery: event.query,
      ));
    } catch (e) {
      emit(ItemListError('Failed to search items: ${e.toString()}'));
    }
  }

  Future<void> _onAddNewItem(AddNewItem event, Emitter<ItemListState> emit) async {
    try {
      final savedItem = await _saveItemUsecase.execute(event.item);
      
      // If item has due date, create notification and alarm
      if (savedItem.due != null && savedItem.id != null) {
        await _createNotificationAndAlarm(savedItem);
      }
      
      if (state is ItemListLoaded) {
        final currentState = state as ItemListLoaded;
        final updatedItems = List<Item>.from(currentState.items)..add(savedItem);
        
        emit(currentState.copyWith(items: updatedItems));
        // Don't emit success message here as it causes state transition issues
      }
    } catch (e) {
      emit(ItemListError('Failed to add item: ${e.toString()}'));
    }
  }

  Future<void> _onUpdateItemTitle(UpdateItemTitle event, Emitter<ItemListState> emit) async {
    try {
      final updatedItem = await _updateItemUsecase.execute(event.item);
      
      if (state is ItemListLoaded) {
        final currentState = state as ItemListLoaded;
        final updatedItems = currentState.items.map((item) {
          return item.id == updatedItem.id ? updatedItem : item;
        }).toList();
        
        emit(currentState.copyWith(
          items: updatedItems,
          isEditing: false,
          editingItemId: null,
        ));
      }
    } catch (e) {
      emit(ItemListError('Failed to update item: ${e.toString()}'));
    }
  }

  Future<void> _onUpdateItem(UpdateItemEvent event, Emitter<ItemListState> emit) async {
    try {
      // Get the old item to compare due dates
      Item? oldItem;
      if (state is ItemListLoaded) {
        final currentState = state as ItemListLoaded;
        oldItem = currentState.items.firstWhere((item) => item.id == event.item.id);
      }
      
      final updatedItem = await _updateItemUsecase.execute(event.item);
      
      // Handle notification changes
      if (updatedItem.id != null) {
        await _handleNotificationChanges(oldItem, updatedItem);
      }
      
      if (state is ItemListLoaded) {
        final currentState = state as ItemListLoaded;
        final updatedItems = currentState.items.map((item) {
          return item.id == updatedItem.id ? updatedItem : item;
        }).toList();
        
        emit(currentState.copyWith(items: updatedItems));
        // Don't emit success message here as it causes state transition issues
      }
    } catch (e) {
      emit(ItemListError('Failed to update item: ${e.toString()}'));
    }
  }

  Future<void> _onDeleteItem(DeleteItemEvent event, Emitter<ItemListState> emit) async {
    try {
      // Get the item to delete notifications
      Item? itemToDelete;
      if (state is ItemListLoaded) {
        final currentState = state as ItemListLoaded;
        try {
          itemToDelete = currentState.items.firstWhere((item) => item.id == event.itemId);
        } catch (e) {
          // Item not found in current list
        }
      }
      
      await _deleteItemUsecase.execute(event.itemId);
      
      // Delete associated notifications and alarms
      if (itemToDelete?.due != null) {
        await _deleteNotificationAndAlarm(event.itemId);
      }
      
      if (state is ItemListLoaded) {
        final currentState = state as ItemListLoaded;
        final updatedItems = currentState.items.where((item) => item.id != event.itemId).toList();
        
        emit(currentState.copyWith(items: updatedItems));
        // Don't emit success message here as it causes state transition issues
      }
    } catch (e) {
      emit(ItemListError('Failed to delete item: ${e.toString()}'));
    }
  }

  Future<void> _onToggleItemCompletion(ToggleItemCompletion event, Emitter<ItemListState> emit) async {
    try {
      final updatedItem = event.item.copyWith(
        flag: event.item.flag == 1 ? 0 : 1, // toggle completion
        completedAt: event.item.flag == 1 ? null : _getCurrentTimeString(),
      );
      
      final savedItem = await _updateItemUsecase.execute(updatedItem);
      
      if (state is ItemListLoaded) {
        final currentState = state as ItemListLoaded;
        final updatedItems = currentState.items.map((item) {
          return item.id == savedItem.id ? savedItem : item;
        }).toList();
        
        emit(currentState.copyWith(items: updatedItems));
      }
    } catch (e) {
      emit(ItemListError('Failed to toggle item completion: ${e.toString()}'));
    }
  }

  Future<void> _onRefreshItemList(RefreshItemList event, Emitter<ItemListState> emit) async {
    if (state is ItemListLoaded) {
      final currentState = state as ItemListLoaded;
      
      if (currentState.searchQuery != null) {
        add(SearchItemsEvent(currentState.searchQuery!));
      } else {
        // type에 따라 reload
        add(LoadItemsByType(type: currentState.type));
      }
    }
  }

  String _getPageTitle(String type, String? categoryName) {
    switch (type) {
      case 'today':
        return '오늘 할 일';
      case 'incomplete':
        return '미완료';
      case 'flagged':
        return '중요 표시';
      case 'highPriority':
        return '높은 우선순위';
      case 'category':
        return categoryName ?? '카테고리';
      case 'search':
        return '검색 결과';
      default:
        return '아이템 목록';
    }
  }

  String _getCurrentTimeString() {
    final now = DateTime.now();
    return '${now.year}_${now.month.toString().padLeft(2, '0')}_${now.day.toString().padLeft(2, '0')}_${now.hour.toString().padLeft(2, '0')}_${now.minute.toString().padLeft(2, '0')}';
  }

  /// Create notification and alarm for item with due date
  Future<void> _createNotificationAndAlarm(Item item) async {
    try {
      if (item.due != null && item.id != null) {
        // Create notification entity
        final notification = Notification(
          notificationId: item.id!,
          timeValue: item.due!,
          title: item.title,
          description: item.description,
        );
        
        // Save notification to database
        await _saveNotificationUsecase.execute(notification);
        
        // Set alarm using local notification
        await _setAlarmUsecase.execute(notification);
      }
    } catch (e) {
      // Log error but don't throw to avoid breaking item creation
      print('Failed to create notification/alarm: $e');
    }
  }

  /// Handle notification changes when item is updated
  Future<void> _handleNotificationChanges(Item? oldItem, Item newItem) async {
    try {
      final oldDue = oldItem?.due;
      final newDue = newItem.due;
      final itemId = newItem.id!;
      
      // If due date was removed
      if (oldDue != null && newDue == null) {
        await _deleteNotificationAndAlarm(itemId);
      }
      // If due date was added
      else if (oldDue == null && newDue != null) {
        await _createNotificationAndAlarm(newItem);
      }
      // If due date was changed
      else if (oldDue != null && newDue != null && oldDue != newDue) {
        // Delete old notification/alarm
        await _deleteNotificationAndAlarm(itemId);
        // Create new notification/alarm
        await _createNotificationAndAlarm(newItem);
      }
      // If only title or description changed but due date exists
      else if (newDue != null && (oldItem?.title != newItem.title || oldItem?.description != newItem.description)) {
        // Update notification
        await _deleteNotificationAndAlarm(itemId);
        await _createNotificationAndAlarm(newItem);
      }
    } catch (e) {
      // Log error but don't throw to avoid breaking item update
      print('Failed to handle notification changes: $e');
    }
  }

  /// Delete notification and alarm for item
  Future<void> _deleteNotificationAndAlarm(int itemId) async {
    try {
      // Delete alarm first
      await _deleteAlarmUsecase.execute(itemId);
      
      // Delete notification from database
      await _deleteNotificationUsecase.execute(itemId);
    } catch (e) {
      // Log error but don't throw to avoid breaking item deletion
      print('Failed to delete notification/alarm: $e');
    }
  }
}


