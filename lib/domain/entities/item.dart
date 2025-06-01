import 'package:equatable/equatable.dart';

class Item extends Equatable {
  final int? id;
  final String title;
  final String? description;
  final String? createdAt;    // YYYY_MM_DD_hh_mm format
  final String? updatedAt;    // YYYY_MM_DD_hh_mm format
  final String? due;          // YYYY_MM_DD_hh_mm format
  final String? completedAt;  // YYYY_MM_DD_hh_mm format
  final int flag;
  final int priority;
  final int? repeatId;
  final int? parentId;
  final int? categoryId;

  const Item({
    this.id,
    required this.title,
    this.description,
    this.createdAt,
    this.updatedAt,
    this.due,
    this.completedAt,
    this.flag = 0,
    this.priority = 3,
    this.repeatId,
    this.parentId,
    this.categoryId,
  });

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    createdAt,
    updatedAt,
    due,
    completedAt,
    flag,
    priority,
    repeatId,
    parentId,
    categoryId,
  ];

  Item copyWith({
    int? id,
    String? title,
    String? description,
    String? createdAt,
    String? updatedAt,
    String? due,
    String? completedAt,
    int? flag,
    int? priority,
    int? repeatId,
    int? parentId,
    int? categoryId,
  }) {
    return Item(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      due: due ?? this.due,
      completedAt: completedAt ?? this.completedAt,
      flag: flag ?? this.flag,
      priority: priority ?? this.priority,
      repeatId: repeatId ?? this.repeatId,
      parentId: parentId ?? this.parentId,
      categoryId: categoryId ?? this.categoryId,
    );
  }
}
