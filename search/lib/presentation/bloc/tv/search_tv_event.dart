part of 'search_tv_bloc.dart';

abstract class SearchTvEvent extends Equatable {
  const SearchTvEvent();

  @override
  List<Object> get props => [];
}

class TvOnQueryChanged extends SearchTvEvent {
  final String query;

  const TvOnQueryChanged(this.query);

  @override
  List<Object> get props => [query];
}
