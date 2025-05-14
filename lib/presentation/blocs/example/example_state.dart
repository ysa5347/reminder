part of 'example_bloc.dart';

abstract class ExampleState extends Equatable {
  const ExampleState();
}

class InitialExampleState extends ExampleState {
  @override
  List<Object> get props => [];
}

class LoadingExampleState extends ExampleState {
  @override
  List<Object> get props => [];
}

class LoadedExampleState extends ExampleState {
  final Example example;
  const LoadedExampleState({required this.example});
  @override
  List<Object> get props => [example];
}
