import 'package:equatable/equatable.dart';

abstract class MainEvent extends Equatable {
  const MainEvent();

  @override
  List<Object> get props => [];
}

class LoadMainData extends MainEvent {}

class RefreshMainData extends MainEvent {}

class SearchItems extends MainEvent {
  final String query;

  const SearchItems(this.query);

  @override
  List<Object> get props => [query];
}
