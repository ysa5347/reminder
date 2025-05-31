import 'package:reminder/domain/entities/notification_entities.dart';

abstract class AlarmEvent {}

class SetAlarmEvent extends AlarmEvent {
  final Notification notification;
  
  SetAlarmEvent(this.notification);
}