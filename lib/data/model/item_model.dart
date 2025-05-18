import 'package:floor/floor.dart';
import '../../domain/entities/item.dart';

@Entity(tableName: 'items')
class ItemModel{
  @PrimaryKey(autoGenerate: true)
  final int? id;
  final String title;
  final String? memo;

  @ColumnInfo(name: 'category_id')
  final int? categoryId;

  @ColumnInfo(name: 'created_at')
  final int? createdAt;

  @ColumnInfo(name: 'updated_at')
  final int? updatedAt;
  final int? due;

  @ColumnInfo(name: 'is_completed')
  final bool isCompleted;

  @ColumnInfo(name: 'is_repeating')
  final bool isRepeating;
  
  // List<Tag> tags;
  // final Repeat repeat;
  // final Notification noti;
  final int flag;
  final int priority;
  @ColumnInfo(name: 'parent_id')
  final int? parentId;

  ItemModel({
    this.id,
    required this.title,
    this.memo,
    this.categoryId,
    this.createdAt,
    this.updatedAt,
    this.due,
    this.isCompleted = false,
    this.isRepeating = false,
    // this.tags = const [],
    // this.repeat,
    // this.noti,
    this.flag = 0,
    this.priority = 0,
    this.parentId
  });

  Item toEntity(){
    return Item(
      id: id,
      title: title,
      memo: memo,
      categoryId: categoryId,
      createdAt: createdAt != null ? DateTime.fromMillisecondsSinceEpoch(createdAt!) : null,
      updatedAt: updatedAt != null ? DateTime.fromMillisecondsSinceEpoch(updatedAt!) : null,
      due: due != null ? DateTime.fromMillisecondsSinceEpoch(due!) : null,
      isCompleted: isCompleted,
      isRepeating: isRepeating,
      // tags: tags,
      // repeat: repeat,
      // noti: noti,
      flag: flag == 1 ? true : false,
      priority: priority,
      parentId: parentId
    );
  }

  factory ItemModel.fromEntity(Item entity){
    return ItemModel(
      id: entity.id,
      title: entity.title,
      memo: entity.memo,
      categoryId: entity.categoryId,
      createdAt: entity.createdAt?.millisecondsSinceEpoch,
      updatedAt: entity.updatedAt?.millisecondsSinceEpoch,
      due: entity.due?.millisecondsSinceEpoch,
      isCompleted: entity.isCompleted,
      isRepeating: entity.isRepeating,
      // tags: entity.tags,
      // repeat: entity.repeat,
      // noti: entity.noti,
      flag: entity.flag ? 1 : 0,
      priority: entity.priority,
      parentId: entity.parentId
    );
  }
}