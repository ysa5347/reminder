import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reminder/domain/entities/example.dart';
import 'package:reminder/domain/usecase/example/get_example_usecase.dart';

part 'example_event.dart';
part 'example_state.dart';

class ReminderBloc extends Bloc<ReminderEvent, ReminderState> {
  final GetSoonestReminderUseCase getSoonestReminder;

  ReminderBloc(this.getSoonestReminder) : super(ReminderInitial()) {
    on<LoadSoonestReminder>((event, emit) async {
      emit(ReminderLoading());  // 로딩 시작
      try {
        final reminder = await getSoonestReminder();  // usecase 실행
        if (reminder != null) {
          emit(ReminderLoaded(reminder));  // 로딩 성공
        } else {
          emit(ReminderError());  // null이면 에러
        }
      } catch (_) {
        emit(ReminderError());  // 예외 발생 시 에러
      }
    });
  }
}
