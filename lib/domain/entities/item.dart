import 'package:equatable/equatable.dart';

class Item extends Equatable{
  final int? id;
  final String title;
  final String? memo;
  final int? categoryId;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? due;
  final bool isCompleted;
  final bool isRepeating;
  final List<String> tags;
  // final Repeat? repeat;       // TODO: class repeat
  // final Notification? noti;   // TODO: class notification
  final bool flag;
  final int priority;
  final int? parentId;

  const Item({
    this.id,
    required this.title,
    this.memo,
    this.categoryId,
    this.createdAt,
    this.updatedAt,
    this.due,
    this.isCompleted = false,
    this.isRepeating = false,
    this.tags = const [],
    // this.repeat,
    // this.noti,
    this.flag = false,
    this.priority = 0,
    this.parentId
  });

  @override
  List<Object?> get props => [
    id,
    title,
    memo,
    createdAt,
    updatedAt,
    due,
    isCompleted,
    tags,
    // repeat,
    // noti,
    flag,
    priority,
    parentId
  ];
}


// class Repeat extends Equatable{
//   //
// }

// class Notification extends Equatable{
//   //
// }