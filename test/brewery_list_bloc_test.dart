import 'package:bloc_test/bloc_test.dart';
import 'package:brewery_explorer/core/errors/network_exception.dart';
import 'package:brewery_explorer/features/breweries/domain/entities/brewery.dart';
import 'package:brewery_explorer/features/breweries/domain/use_cases/get_breweries_use_case.dart';
import 'package:brewery_explorer/features/breweries/domain/use_cases/search_breweries_use_case.dart';
import 'package:brewery_explorer/features/breweries/presentation/controllers/brewery_list_bloc.dart';
import 'package:brewery_explorer/features/breweries/presentation/controllers/brewery_list_event.dart';
import 'package:brewery_explorer/features/breweries/presentation/controllers/brewery_list_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockGetBreweriesUseCase extends Mock implements GetBreweriesUseCase {}

class _MockSearchBreweriesUseCase extends Mock
    implements SearchBreweriesUseCase {}

void main() {
  late _MockGetBreweriesUseCase getBreweries;
  late _MockSearchBreweriesUseCase searchBreweries;

  const brewery = Brewery(
    id: '1',
    name: 'Test Brewery',
    breweryType: 'micro',
    city: 'Santiago',
    latitude: -33.45,
    longitude: -70.66,
  );

  setUp(() {
    getBreweries = _MockGetBreweriesUseCase();
    searchBreweries = _MockSearchBreweriesUseCase();
  });

  BreweryListBloc buildBloc() {
    return BreweryListBloc(getBreweries, searchBreweries);
  }

  group('BreweryListBloc', () {
    blocTest<BreweryListBloc, BreweryListState>(
      'emite loading y success al iniciar',
      build: buildBloc,
      setUp: () {
        when(
          () => getBreweries(
            page: any(named: 'page'),
            perPage: any(named: 'perPage'),
            cancelToken: any(named: 'cancelToken'),
          ),
        ).thenAnswer((_) async => const [brewery]);
      },
      act: (bloc) => bloc.add(const BreweryListStarted()),
      expect: () => [
        isA<BreweryListLoading>(),
        isA<BreweryListSuccess>()
            .having((s) => s.breweries, 'breweries', const [brewery])
            .having((s) => s.hasMore, 'hasMore', false),
      ],
    );

    blocTest<BreweryListBloc, BreweryListState>(
      'emite loading y failure cuando la carga falla',
      build: buildBloc,
      setUp: () {
        when(
          () => getBreweries(
            page: any(named: 'page'),
            perPage: any(named: 'perPage'),
            cancelToken: any(named: 'cancelToken'),
          ),
        ).thenThrow(const NetworkException());
      },
      act: (bloc) => bloc.add(const BreweryListStarted()),
      expect: () => [
        isA<BreweryListLoading>(),
        isA<BreweryListFailure>().having(
          (s) => s.message,
          'message',
          'No se pudo conectar con el servidor.',
        ),
      ],
    );

    blocTest<BreweryListBloc, BreweryListState>(
      'emite empty cuando la lista viene vacía',
      build: buildBloc,
      setUp: () {
        when(
          () => getBreweries(
            page: any(named: 'page'),
            perPage: any(named: 'perPage'),
            cancelToken: any(named: 'cancelToken'),
          ),
        ).thenAnswer((_) async => const []);
      },
      act: (bloc) => bloc.add(const BreweryListStarted()),
      expect: () => [
        isA<BreweryListLoading>(),
        isA<BreweryListEmpty>(),
      ],
    );

    blocTest<BreweryListBloc, BreweryListState>(
      'search con debounce emite loading y success',
      build: buildBloc,
      setUp: () {
        when(
          () => searchBreweries(
            query: any(named: 'query'),
            cancelToken: any(named: 'cancelToken'),
          ),
        ).thenAnswer((_) async => const [brewery]);
      },
      act: (bloc) => bloc.add(const BreweryListSearchChanged('ipa')),
      wait: const Duration(milliseconds: 400),
      expect: () => [
        isA<BreweryListLoading>().having((s) => s.query, 'query', 'ipa'),
        isA<BreweryListSuccess>()
            .having((s) => s.breweries, 'breweries', const [brewery])
            .having((s) => s.query, 'query', 'ipa')
            .having((s) => s.hasMore, 'hasMore', false),
      ],
      verify: (_) {
        verify(
          () => searchBreweries(
            query: 'ipa',
            cancelToken: any(named: 'cancelToken'),
          ),
        ).called(1);
      },
    );

    blocTest<BreweryListBloc, BreweryListState>(
      'search rápido solo dispara una request tras el debounce',
      build: buildBloc,
      setUp: () {
        when(
          () => searchBreweries(
            query: any(named: 'query'),
            cancelToken: any(named: 'cancelToken'),
          ),
        ).thenAnswer((_) async => const [brewery]);
      },
      act: (bloc) async {
        bloc.add(const BreweryListSearchChanged('i'));
        bloc.add(const BreweryListSearchChanged('ip'));
        bloc.add(const BreweryListSearchChanged('ipa'));
      },
      wait: const Duration(milliseconds: 400),
      expect: () => [
        isA<BreweryListLoading>().having((s) => s.query, 'query', 'ipa'),
        isA<BreweryListSuccess>().having((s) => s.query, 'query', 'ipa'),
      ],
      verify: (_) {
        verify(
          () => searchBreweries(
            query: 'ipa',
            cancelToken: any(named: 'cancelToken'),
          ),
        ).called(1);
        verifyNever(
          () => searchBreweries(
            query: 'i',
            cancelToken: any(named: 'cancelToken'),
          ),
        );
        verifyNever(
          () => searchBreweries(
            query: 'ip',
            cancelToken: any(named: 'cancelToken'),
          ),
        );
      },
    );

    blocTest<BreweryListBloc, BreweryListState>(
      'search sin resultados emite empty',
      build: buildBloc,
      setUp: () {
        when(
          () => searchBreweries(
            query: any(named: 'query'),
            cancelToken: any(named: 'cancelToken'),
          ),
        ).thenAnswer((_) async => const []);
      },
      act: (bloc) => bloc.add(const BreweryListSearchChanged('xyz')),
      wait: const Duration(milliseconds: 400),
      expect: () => [
        isA<BreweryListLoading>(),
        isA<BreweryListEmpty>().having((s) => s.query, 'query', 'xyz'),
      ],
    );
  });
}
