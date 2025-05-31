abstract class AlarmState {}

class AlarmInitial extends AlarmState {}

class AlarmLoading extends AlarmState {}

class AlarmSuccess extends AlarmState {}

class AlarmError extends AlarmState {
  final String message;
  
  AlarmError(this.message);
}