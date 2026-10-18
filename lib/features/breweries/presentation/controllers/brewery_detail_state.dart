import 'package:brewery_explorer/features/breweries/domain/entities/brewery.dart';
import 'package:equatable/equatable.dart';

sealed class BreweryDetailState extends Equatable {
  const BreweryDetailState();

  @override
  List<Object?> get props => const [];
}

final class BreweryDetailInitial extends BreweryDetailState {
  const BreweryDetailInitial();
}

final class BreweryDetailLoading extends BreweryDetailState {
  const BreweryDetailLoading();
}

final class BreweryDetailSuccess extends BreweryDetailState {
  const BreweryDetailSuccess(this.brewery);

  final Brewery brewery;

  @override
  List<Object?> get props => [brewery];
}

final class BreweryDetailFailure extends BreweryDetailState {
  const BreweryDetailFailure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
