import 'package:floor/floor.dart';

@Entity(
  tableName: 'repeats'
)
class RepeatModel{
  @PrimaryKey(autoGenerate: true)
  final int? id;

  @ColumnInfo(name: 'weekday_byte')
  final int? weekdayByte;
  @ColumnInfo(name: 'week_byte')
  final int? weekByte;

  @ColumnInfo(name: 'created_at')
  final int? createdAt;
  @ColumnInfo(name: 'updated_at')
  final int? updatedAt;

  @ColumnInfo(name: 'start_day')
  final int? startDay;
  @ColumnInfo(name: 'end_day')
  final int? endDay;

  RepeatModel({
    this.id,
    this.weekdayByte,
    this.weekByte,
    this.createdAt,
    this.updatedAt,
    this.startDay,
    this.endDay
  });
}