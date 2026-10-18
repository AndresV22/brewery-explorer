import 'package:brewery_explorer/features/breweries/domain/entities/brewery.dart';
import 'package:equatable/equatable.dart';

sealed class BreweryListState extends Equatable {
  const BreweryListState();

  @override
  List<Object?> get props => const [];
}

final class BreweryListInitial extends BreweryListState {
  const BreweryListInitial();
}

final class BreweryListLoading extends BreweryListState {
  const BreweryListLoading();
}

final class BreweryListSuccess extends BreweryListState {
  const BreweryListSuccess({
    required this.breweries,
    required this.hasMore,
    required this.isLoadingMore,
  });

  final List<Brewery> breweries;
  final bool hasMore;
  final bool isLoadingMore;

  BreweryListSuccess copyWith({
    List<Brewery>? breweries,
    bool? hasMore,
    bool? isLoadingMore,
  }) {
    return BreweryListSuccess(
      breweries: breweries ?? this.breweries,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }

  @override
  List<Object?> get props => [breweries, hasMore, isLoadingMore];
}

final class BreweryListEmpty extends BreweryListState {
  const BreweryListEmpty();
}

final class BreweryListFailure extends BreweryListState {
  const BreweryListFailure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
