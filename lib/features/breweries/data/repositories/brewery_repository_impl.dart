import 'package:brewery_explorer/features/breweries/data/data_sources/brewery_remote_data_source.dart';
import 'package:brewery_explorer/features/breweries/domain/repositories/brewery_repository.dart';
import 'package:brewery_explorer/features/breweries/data/mappers/brewery_mapper.dart';
import 'package:brewery_explorer/features/breweries/domain/entities/brewery.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: BreweryRepository)
class BreweryRepositoryImpl implements BreweryRepository {
  BreweryRepositoryImpl(this._api, this._mapper);

  final BreweryRemoteDataSource _api;
  final BreweryMapper _mapper;

  @override
  Future<List<Brewery>> getBreweries({
    required int page,
    int perPage = 20,
    CancelToken? cancelToken,
  }) async {
    final dtos = await _api.fetchBreweries(
      page: page,
      perPage: perPage,
      cancelToken: cancelToken,
    );
    return _mapper.toEntityList(dtos);
  }

  @override
  Future<Brewery> getBreweryById(
    String id, {
    CancelToken? cancelToken,
  }) async {
    final dto = await _api.fetchBreweryById(id, cancelToken: cancelToken);
    return _mapper.toEntity(dto);
  }

  @override
  Future<List<Brewery>> searchBreweries({
    required String query,
    CancelToken? cancelToken,
  }) async {
    final dtos = await _api.searchBreweries(
      query: query,
      cancelToken: cancelToken,
    );
    return _mapper.toEntityList(dtos);
  }
}
