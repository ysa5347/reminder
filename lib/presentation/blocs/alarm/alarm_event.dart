import 'package:equatable/equatable.dart';
import '../../../domain/entities/notification_entities.dart';

abstract class AlarmEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class SetAlarmEvent extends AlarmEvent {
  final Notification notification;
  
  SetAlarmEvent(this.notification);
  
  @override
  List<Object> get props => [notification];
}

class LoadNotificationsEvent extends AlarmEvent {}

class DeleteAlarmByIdEvent extends AlarmEvent {
  final int notificationId;
  
  DeleteAlarmByIdEvent(this.notificationId);
  
  @override
  List<Object> get props => [notificationId];
}

class ClearAllAlarmsEvent extends AlarmEvent {}
