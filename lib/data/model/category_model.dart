import 'package:floor/floor.dart';

@Entity(
  tableName: 'categories'
)
class CategoryModel{
  @PrimaryKey(autoGenerate: true)
  final int? id;
  final String title;
  final String? description;
  final String? color;
  final String? icon;

  @ColumnInfo(name: 'created_at')
  final int? createdAt;
  @ColumnInfo(name: 'updated_at')
  final int? updatedAt;

  // final String? image;
  // final enum type; 

  CategoryModel({
    this.id,
    required this.title,
    this.description,
    this.color,
    this.icon,
    this.createdAt,
    this.updatedAt
    // this.image,
    // this.type
  });
}