import 'package:brewery_explorer/features/breweries/domain/entities/brewery.dart';
import 'package:equatable/equatable.dart';

sealed class BreweryListState extends Equatable {
  const BreweryListState({this.query = ''});

  final String query;

  @override
  List<Object?> get props => [query];
}

final class BreweryListInitial extends BreweryListState {
  const BreweryListInitial();
}

final class BreweryListLoading extends BreweryListState {
  const BreweryListLoading({super.query});
}

final class BreweryListSuccess extends BreweryListState {
  const BreweryListSuccess({
    required this.breweries,
    required this.hasMore,
    required this.isLoadingMore,
    super.query,
  });

  final List<Brewery> breweries;
  final bool hasMore;
  final bool isLoadingMore;

  BreweryListSuccess copyWith({
    List<Brewery>? breweries,
    bool? hasMore,
    bool? isLoadingMore,
    String? query,
  }) {
    return BreweryListSuccess(
      breweries: breweries ?? this.breweries,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      query: query ?? this.query,
    );
  }

  @override
  List<Object?> get props => [breweries, hasMore, isLoadingMore, query];
}

final class BreweryListEmpty extends BreweryListState {
  const BreweryListEmpty({super.query});
}

final class BreweryListFailure extends BreweryListState {
  const BreweryListFailure({
    required this.message,
    super.query,
  });

  final String message;

  @override
  List<Object?> get props => [message, query];
}
