import 'package:equatable/equatable.dart';

class Category extends Equatable {
  final int? id;
  final String name;
  final String? description;
  final String? color;
  final String? icon;
  final String? createdAt;    // YYYY_MM_DD_hh_mm format
  final String? updatedAt;    // YYYY_MM_DD_hh_mm format

  const Category({
    this.id,
    required this.name,
    this.description,
    this.color,
    this.icon,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        color,
        icon,
        createdAt,
        updatedAt,
      ];
}