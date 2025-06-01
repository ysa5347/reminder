import 'package:equatable/equatable.dart';
import '../../../domain/entities/item.dart';

abstract class ItemListState extends Equatable {
  const ItemListState();

  @override
  List<Object?> get props => [];
}

class ItemListInitial extends ItemListState {
  const ItemListInitial();
}

class ItemListLoading extends ItemListState {
  const ItemListLoading();
}

class ItemListLoaded extends ItemListState {
  final List<Item> items;
  final String type;
  final String title;
  final String? searchQuery;
  final bool isEditing;
  final int? editingItemId;

  const ItemListLoaded({
    required this.items,
    required this.type,
    required this.title,
    this.searchQuery,
    this.isEditing = false,
    this.editingItemId,
  });

  ItemListLoaded copyWith({
    List<Item>? items,
    String? type,
    String? title,
    String? searchQuery,
    bool? isEditing,
    int? editingItemId,
  }) {
    return ItemListLoaded(
      items: items ?? this.items,
      type: type ?? this.type,
      title: title ?? this.title,
      searchQuery: searchQuery ?? this.searchQuery,
      isEditing: isEditing ?? this.isEditing,
      editingItemId: editingItemId ?? this.editingItemId,
    );
  }

  @override
  List<Object?> get props => [items, type, title, searchQuery, isEditing, editingItemId];
}

class ItemListError extends ItemListState {
  final String message;

  const ItemListError(this.message);

  @override
  List<Object> get props => [message];
}
