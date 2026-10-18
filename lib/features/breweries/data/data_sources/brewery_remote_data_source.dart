import 'package:brewery_explorer/features/breweries/data/models/brewery_dto.dart';
import 'package:brewery_explorer/core/errors/network_exception.dart';
import 'package:brewery_explorer/core/errors/not_found_exception.dart';
import 'package:brewery_explorer/core/errors/server_exception.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class BreweryRemoteDataSource {
  BreweryRemoteDataSource(this._dio);

  final Dio _dio;

  Future<List<BreweryDto>> fetchBreweries({
    required int page,
    required int perPage,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.get<List<dynamic>>(
        '/breweries',
        queryParameters: <String, dynamic>{
          'page': page,
          'per_page': perPage,
        },
        cancelToken: cancelToken,
      );
      return _parseList(response.data);
    } on DioException catch (error) {
      throw _mapDioException(error);
    }
  }

  Future<BreweryDto> fetchBreweryById(
    String id, {
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        '/breweries/$id',
        cancelToken: cancelToken,
      );
      final data = response.data;
      if (data == null) {
        throw const NotFoundException();
      }
      return BreweryDto.fromJson(data);
    } on DioException catch (error) {
      throw _mapDioException(error);
    }
  }

  Future<List<BreweryDto>> searchBreweries({
    required String query,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.get<List<dynamic>>(
        '/breweries/search',
        queryParameters: <String, dynamic>{'query': query},
        cancelToken: cancelToken,
      );
      return _parseList(response.data);
    } on DioException catch (error) {
      throw _mapDioException(error);
    }
  }

  List<BreweryDto> _parseList(List<dynamic>? data) {
    if (data == null) {
      return const <BreweryDto>[];
    }
    return data
        .whereType<Map<String, dynamic>>()
        .map(BreweryDto.fromJson)
        .toList(growable: false);
  }

  Never _mapDioException(DioException error) {
    if (error.type == DioExceptionType.cancel) {
      throw error;
    }
    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout ||
        error.type == DioExceptionType.sendTimeout ||
        error.type == DioExceptionType.connectionError) {
      throw const NetworkException();
    }
    final statusCode = error.response?.statusCode;
    if (statusCode == 404) {
      throw const NotFoundException();
    }
    throw const ServerException();
  }
}
