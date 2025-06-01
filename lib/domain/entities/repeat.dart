import 'package:equatable/equatable.dart';

class Repeat extends Equatable {
  final int? id;
  final int? weekdayByte;
  final int? weekByte;
  final String? createdAt;  // YYYY_MM_DD_hh_mm format
  final String? updatedAt;  // YYYY_MM_DD_hh_mm format
  final String? startDay;   // YYYY_MM_DD_hh_mm format
  final String? endDay;     // YYYY_MM_DD_hh_mm format

  const Repeat({
    this.id,
    this.weekdayByte,
    this.weekByte,
    this.createdAt,
    this.updatedAt,
    this.startDay,
    this.endDay,
  });

  @override
  List<Object?> get props => [
    id,
    weekdayByte,
    weekByte,
    createdAt,
    updatedAt,
    startDay,
    endDay,
  ];
}