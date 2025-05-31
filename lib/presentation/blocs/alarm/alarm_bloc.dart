import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecase/Alarm/SetAlarm_usecase.dart';
import 'alarm_event.dart';
import 'alarm_state.dart';

class AlarmBloc extends Bloc<AlarmEvent, AlarmState> {
  final SetAlarmUsecase setAlarmUsecase;

  AlarmBloc(this.setAlarmUsecase) : super(AlarmInitial()) {
    on<SetAlarmEvent>(_onSetAlarm);
  }

  void _onSetAlarm(SetAlarmEvent event, Emitter<AlarmState> emit) async {
    emit(AlarmLoading());
    
    try {
      await setAlarmUsecase.execute(event.notification);
      emit(AlarmSuccess());
    } catch (e) {
      emit(AlarmError(e.toString()));
    }
  }
}