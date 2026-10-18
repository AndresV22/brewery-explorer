// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'package:brewery_explorer/core/network/register_module.dart' as _i457;
import 'package:brewery_explorer/features/breweries/data/data_sources/brewery_remote_data_source.dart'
    as _i88;
import 'package:brewery_explorer/features/breweries/data/mappers/brewery_mapper.dart'
    as _i97;
import 'package:brewery_explorer/features/breweries/data/repositories/brewery_repository_impl.dart'
    as _i741;
import 'package:brewery_explorer/features/breweries/domain/repositories/brewery_repository.dart'
    as _i406;
import 'package:brewery_explorer/features/breweries/domain/use_cases/get_breweries_use_case.dart'
    as _i371;
import 'package:brewery_explorer/features/breweries/domain/use_cases/get_brewery_by_id_use_case.dart'
    as _i1024;
import 'package:brewery_explorer/features/breweries/domain/use_cases/search_breweries_use_case.dart'
    as _i910;
import 'package:brewery_explorer/features/breweries/presentation/controllers/brewery_detail_cubit.dart'
    as _i259;
import 'package:brewery_explorer/features/breweries/presentation/controllers/brewery_list_bloc.dart'
    as _i931;
import 'package:dio/dio.dart' as _i361;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final registerModule = _$RegisterModule();
    gh.lazySingleton<_i361.Dio>(() => registerModule.dio());
    gh.lazySingleton<_i97.BreweryMapper>(() => _i97.BreweryMapper());
    gh.lazySingleton<_i88.BreweryRemoteDataSource>(
      () => _i88.BreweryRemoteDataSource(gh<_i361.Dio>()),
    );
    gh.lazySingleton<_i406.BreweryRepository>(
      () => _i741.BreweryRepositoryImpl(
        gh<_i88.BreweryRemoteDataSource>(),
        gh<_i97.BreweryMapper>(),
      ),
    );
    gh.lazySingleton<_i371.GetBreweriesUseCase>(
      () => _i371.GetBreweriesUseCase(gh<_i406.BreweryRepository>()),
    );
    gh.lazySingleton<_i1024.GetBreweryByIdUseCase>(
      () => _i1024.GetBreweryByIdUseCase(gh<_i406.BreweryRepository>()),
    );
    gh.lazySingleton<_i910.SearchBreweriesUseCase>(
      () => _i910.SearchBreweriesUseCase(gh<_i406.BreweryRepository>()),
    );
    gh.factory<_i259.BreweryDetailCubit>(
      () => _i259.BreweryDetailCubit(gh<_i1024.GetBreweryByIdUseCase>()),
    );
    gh.factory<_i931.BreweryListBloc>(
      () => _i931.BreweryListBloc(gh<_i371.GetBreweriesUseCase>()),
    );
    return this;
  }
}

class _$RegisterModule extends _i457.RegisterModule {}
