import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecase/Alarm/SetAlarm_usecase.dart';
import '../../../domain/usecase/Alarm/DeleteAlarm_usecase.dart';
import '../../../domain/usecase/notification/GetNotifications_usecase.dart';
import '../../../domain/repository/notification_repository.dart';
import 'alarm_event.dart';
import 'alarm_state.dart';

class AlarmBloc extends Bloc<AlarmEvent, AlarmState> {
  final SetAlarmUsecase setAlarmUsecase;
  final DeleteAlarmUsecase deleteAlarmUsecase;
  final NotificationRepository notificationRepository;

  AlarmBloc({
    required this.setAlarmUsecase,
    required this.deleteAlarmUsecase,
    required this.notificationRepository,
  }) : super(AlarmInitial()) {
    on<SetAlarmEvent>(_onSetAlarm);
    on<LoadNotificationsEvent>(_onLoadNotifications);
    on<DeleteAlarmByIdEvent>(_onDeleteAlarmById);
    on<ClearAllAlarmsEvent>(_onClearAllAlarms);
  }

  void _onSetAlarm(SetAlarmEvent event, Emitter<AlarmState> emit) async {
    emit(AlarmLoading());
    
    try {
      await setAlarmUsecase.execute(
        event.notification.notificationId,
        event.notification.timeValue,
        event.notification.title,
        event.notification.description ?? '',
      );
      emit(AlarmSuccess('알람이 설정되었습니다'));
    } catch (e) {
      emit(AlarmError(e.toString()));
    }
  }

  void _onLoadNotifications(LoadNotificationsEvent event, Emitter<AlarmState> emit) async {
    emit(AlarmLoading());
    
    try {
      // Get all notifications from database
      // Since we don't have a getAllNotifications method, we'll use a workaround
      final List<dynamic> allNotifications = [];
      
      // Try to get notifications with different IDs (this is a debug method)
      for (int i = 1; i <= 1000; i++) {
        try {
          final notifications = await notificationRepository.getNotificationsById(i);
          allNotifications.addAll(notifications);
        } catch (e) {
          // Continue if notification doesn't exist
        }
      }
      
      emit(NotificationsLoaded(allNotifications.cast()));
    } catch (e) {
      emit(AlarmError('알람 목록을 불러오는데 실패했습니다: ${e.toString()}'));
    }
  }

  void _onDeleteAlarmById(DeleteAlarmByIdEvent event, Emitter<AlarmState> emit) async {
    emit(AlarmLoading());
    
    try {
      await deleteAlarmUsecase.execute(event.notificationId);
      emit(AlarmSuccess('알람이 삭제되었습니다'));
    } catch (e) {
      emit(AlarmError('알람 삭제에 실패했습니다: ${e.toString()}'));
    }
  }

  void _onClearAllAlarms(ClearAllAlarmsEvent event, Emitter<AlarmState> emit) async {
    emit(AlarmLoading());
    
    try {
      // Clear all alarms by deleting notifications with IDs 1-1000
      int deletedCount = 0;
      for (int i = 1; i <= 1000; i++) {
        try {
          await deleteAlarmUsecase.execute(i);
          deletedCount++;
        } catch (e) {
          // Continue if notification doesn't exist
        }
      }
      
      emit(AlarmSuccess('모든 알람이 삭제되었습니다 ($deletedCount개)'));
    } catch (e) {
      emit(AlarmError('알람 전체 삭제에 실패했습니다: ${e.toString()}'));
    }
  }
}