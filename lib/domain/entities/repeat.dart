import 'package:equatable/equatable.dart';

class Repeat{
  final int? id;
  final int? weekdayByte;
  final int? weekByte;

  final int? createdAt;
  final int? updatedAt;

  final int? startDay;
  final int? endDay;

  Repeat({
    this.id,
    this.weekdayByte,
    this.weekByte,
    this.createdAt,
    this.updatedAt,
    this.startDay,
    this.endDay
  });
}