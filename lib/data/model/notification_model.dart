import 'package:floor/floor.dart';
import './item_model.dart';

@Entity(
  tableName: 'notifications',
  foreignKeys: [
    ForeignKey(
      childColumns: ['item_id'],
      parentColumns: ['id'],
      entity: ItemModel,
      onUpdate: ForeignKeyAction.cascade,
      onDelete: ForeignKeyAction.cascade
    )
  ]
)
class NotificationModel{
  @PrimaryKey(autoGenerate: true)
  final int? id;

  @ColumnInfo(name: 'created_at')
  final int? createdAt;           // milliseconds
  
  @ColumnInfo(name: 'item_id')
  final int? itemId;
  
  final int? time;
  final int priority;
  final int queue;

  NotificationModel({
    this.id,
    this.createdAt,
    this.itemId,
    this.time,
    this.priority   = 3,
    this.queue      = 1
  });
}