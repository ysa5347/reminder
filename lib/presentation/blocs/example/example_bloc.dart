import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reminder/domain/entities/example.dart';
import 'package:reminder/domain/usecase/example/get_example_usecase.dart';

part 'example_event.dart';
part 'example_state.dart';

class ExampleBloc extends Bloc<ExampleEvent, ExampleState> {
  ExampleBloc({required GetExampleUseCase getExampleUseCase})
    : _getExampleUseCase = getExampleUseCase,
      super(InitialExampleState()) {
    on<GetExampleEvent>(_onGetExample);
  }

  final GetExampleUseCase _getExampleUseCase;

  Future<void> _onGetExample(
    GetExampleEvent event,
    Emitter<ExampleState> emit,
  ) async {
    emit(LoadingExampleState());
    final result = await _getExampleUseCase.execute();
    emit(LoadedExampleState(example: result));
  }
}
