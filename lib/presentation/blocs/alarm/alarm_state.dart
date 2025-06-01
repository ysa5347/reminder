import 'package:equatable/equatable.dart';
import '../../../domain/entities/notification_entities.dart';

abstract class AlarmState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AlarmInitial extends AlarmState {}

class AlarmLoading extends AlarmState {}

class AlarmSuccess extends AlarmState {
  final String? message;
  
  AlarmSuccess([this.message]);
  
  @override
  List<Object?> get props => [message];
}

class AlarmError extends AlarmState {
  final String message;
  
  AlarmError(this.message);
  
  @override
  List<Object> get props => [message];
}

class NotificationsLoaded extends AlarmState {
  final List<Notification> notifications;
  
  NotificationsLoaded(this.notifications);
  
  @override
  List<Object> get props => [notifications];
}