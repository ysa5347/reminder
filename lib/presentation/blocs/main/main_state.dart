import 'package:equatable/equatable.dart';
import '../../../domain/entities/category.dart';

abstract class MainState extends Equatable {
  const MainState();

  @override
  List<Object> get props => [];
}

class MainInitial extends MainState {}

class MainLoading extends MainState {}

class MainLoaded extends MainState {
  final List<Category> categories;
  final int todayItemsCount;
  final int incompleteItemsCount;
  final int flaggedItemsCount;
  final int highPriorityItemsCount;

  const MainLoaded({
    required this.categories,
    required this.todayItemsCount,
    required this.incompleteItemsCount,
    required this.flaggedItemsCount,
    required this.highPriorityItemsCount,
  });

  @override
  List<Object> get props => [
        categories,
        todayItemsCount,
        incompleteItemsCount,
        flaggedItemsCount,
        highPriorityItemsCount,
      ];
}

class MainError extends MainState {
  final String message;

  const MainError(this.message);

  @override
  List<Object> get props => [message];
}
