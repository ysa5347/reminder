import 'package:equatable/equatable.dart';
import '../../../domain/entities/item.dart';

abstract class ItemListEvent extends Equatable {
  const ItemListEvent();

  @override
  List<Object?> get props => [];
}

class LoadItemsByType extends ItemListEvent {
  final String type;
  final int? categoryId;
  final String? categoryName;

  const LoadItemsByType({
    required this.type,
    this.categoryId,
    this.categoryName,
  });

  @override
  List<Object?> get props => [type, categoryId, categoryName];
}

class SearchItemsEvent extends ItemListEvent {
  final String query;

  const SearchItemsEvent(this.query);

  @override
  List<Object> get props => [query];
}

class AddNewItem extends ItemListEvent {
  final Item item;

  const AddNewItem(this.item);

  @override
  List<Object> get props => [item];
}

class UpdateItemTitle extends ItemListEvent {
  final Item item;

  const UpdateItemTitle(this.item);

  @override
  List<Object> get props => [item];
}

class UpdateItemEvent extends ItemListEvent {
  final Item item;

  const UpdateItemEvent(this.item);

  @override
  List<Object> get props => [item];
}

class DeleteItemEvent extends ItemListEvent {
  final int itemId;

  const DeleteItemEvent(this.itemId);

  @override
  List<Object> get props => [itemId];
}

class ToggleItemCompletion extends ItemListEvent {
  final Item item;

  const ToggleItemCompletion(this.item);

  @override
  List<Object> get props => [item];
}

class RefreshItemList extends ItemListEvent {
  const RefreshItemList();
}
