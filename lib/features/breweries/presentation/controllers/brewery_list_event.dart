import 'package:equatable/equatable.dart';

sealed class BreweryListEvent extends Equatable {
  const BreweryListEvent();

  @override
  List<Object?> get props => const [];
}

final class BreweryListStarted extends BreweryListEvent {
  const BreweryListStarted();
}

final class BreweryListRetried extends BreweryListEvent {
  const BreweryListRetried();
}

final class BreweryListLoadMoreRequested extends BreweryListEvent {
  const BreweryListLoadMoreRequested();
}

final class BreweryListSearchChanged extends BreweryListEvent {
  const BreweryListSearchChanged(this.query);

  final String query;

  @override
  List<Object?> get props => [query];
}

final class BreweryListSearchCleared extends BreweryListEvent {
  const BreweryListSearchCleared();
}
