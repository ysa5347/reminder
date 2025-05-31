import 'package:equatable/equatable.dart';

class Notification extends Equatable {
  final int notificationId;
  final String timeValue;  // YYYY_MM_DD_hh_mm format
  final String title;
  final String? description;

  const Notification({
    required this.notificationId,
    required this.timeValue,
    required this.title,
    this.description,
  });

  @override
  List<Object?> get props => [
    notificationId,
    timeValue,
    title,
    description,
  ];
}