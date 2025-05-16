import 'package:equatable/equatable.dart';

class Category extends Equatable {
  final int? id;
  final String name;
  final String? color;
  final String? icon;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Category({
    this.id,
    required this.name,
    this.color,
    this.icon,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        color,
        icon,
        createdAt,
        updatedAt,
      ];
}