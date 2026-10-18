import 'package:brewery_explorer/features/breweries/domain/entities/brewery.dart';
import 'package:brewery_explorer/features/breweries/domain/repositories/brewery_repository.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class SearchBreweriesUseCase {
  SearchBreweriesUseCase(this._repository);

  final BreweryRepository _repository;

  Future<List<Brewery>> call({
    required String query,
    CancelToken? cancelToken,
  }) {
    return _repository.searchBreweries(
      query: query,
      cancelToken: cancelToken,
    );
  }
}
