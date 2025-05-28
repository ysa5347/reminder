import 'package:floor/floor.dart';
import './category_model.dart';

@Entity(
  tableName: 'items',
  foreignKeys: [
    ForeignKey(
      childColumns: ['category_id'],
      parentColumns: ['id'],
      entity: CategoryModel,
      onUpdate: ForeignKeyAction.cascade,
      onDelete: ForeignKeyAction.cascade
    )
  ]
)
class ItemModel{
  @PrimaryKey(autoGenerate: true)
  final int? id;
  final String title;
  final String? description;

  @ColumnInfo(name: 'created_at')
  final int? createdAt;
  @ColumnInfo(name: 'updated_at')
  final int? updatedAt;
  final int? due;
  @ColumnInfo(name: 'completed_at')
  final int? completedAt;

  final int flag;
  final int priority;

  @ColumnInfo(name: 'repeat_id')
  final int? repeatId;
  @ColumnInfo(name: 'parent_id')
  final int? parentId;
  @ColumnInfo(name: 'category_id')
  final int? categoryId;  

  ItemModel({
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
    this.categoryId
  });
}