import 'package:brewery_explorer/features/breweries/domain/entities/brewery.dart';
import 'package:dio/dio.dart';

abstract class BreweryRepository {
  Future<List<Brewery>> getBreweries({
    required int page,
    int perPage = 20,
    CancelToken? cancelToken,
  });

  Future<Brewery> getBreweryById(
    String id, {
    CancelToken? cancelToken,
  });

  Future<List<Brewery>> searchBreweries({
    required String query,
    CancelToken? cancelToken,
  });
}
