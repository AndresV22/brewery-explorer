import 'package:brewery_explorer/features/breweries/domain/entities/brewery.dart';
import 'package:brewery_explorer/features/breweries/domain/repositories/brewery_repository.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class GetBreweriesUseCase {
  GetBreweriesUseCase(this._repository);

  final BreweryRepository _repository;

  Future<List<Brewery>> call({
    required int page,
    int perPage = 20,
    CancelToken? cancelToken,
  }) {
    return _repository.getBreweries(
      page: page,
      perPage: perPage,
      cancelToken: cancelToken,
    );
  }
}
