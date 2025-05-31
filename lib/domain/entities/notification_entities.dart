import 'package:equatable/equatable.dart';

class Notification{
  final int notificationId;
  final String timevalue;
  final String title;
  final String? description;

  Notification({
    required this.notificationId,
    required this.timevalue,
    required this.title,
    this.description,
  });
}
class Item{
  final int itemId;
  final String title;
  final String description;
  final String? due;
  final String? period;
  final int priority;
  final int? repeatId;
  final int? parentId;
  final int? categoryId;

  Item({
    required this.itemId,
    required this.title,
    required this.description,
    required this.priority,
    this.repeatId,
    this.parentId,
    this.due,
    this.period,
    this.categoryId,
  });
}