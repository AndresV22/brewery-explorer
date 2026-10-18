import 'package:brewery_explorer/features/breweries/domain/entities/brewery.dart';
import 'package:brewery_explorer/features/breweries/domain/repositories/brewery_repository.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class GetBreweryByIdUseCase {
  GetBreweryByIdUseCase(this._repository);

  final BreweryRepository _repository;

  Future<Brewery> call(
    String id, {
    CancelToken? cancelToken,
  }) {
    return _repository.getBreweryById(id, cancelToken: cancelToken);
  }
}
