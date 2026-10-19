import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:brewery_explorer/core/errors/brewery_exception.dart';
import 'package:brewery_explorer/features/breweries/domain/use_cases/get_breweries_use_case.dart';
import 'package:brewery_explorer/features/breweries/domain/use_cases/search_breweries_use_case.dart';
import 'package:brewery_explorer/features/breweries/presentation/controllers/brewery_list_event.dart';
import 'package:brewery_explorer/features/breweries/presentation/controllers/brewery_list_state.dart';
import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:stream_transform/stream_transform.dart';

EventTransformer<E> _debounceRestartable<E>({
  Duration duration = const Duration(milliseconds: 350),
}) {
  return (events, mapper) {
    return restartable<E>().call(
      events.debounce(duration),
      mapper,
    );
  };
}

@injectable
class BreweryListBloc extends Bloc<BreweryListEvent, BreweryListState> {
  BreweryListBloc(
    this._getBreweries,
    this._searchBreweries,
  )   : searchController = TextEditingController(),
        scrollController = ScrollController(),
        super(const BreweryListInitial()) {
    on<BreweryListStarted>(_onStarted);
    on<BreweryListRetried>(_onRetried);
    on<BreweryListLoadMoreRequested>(_onLoadMore);
    on<BreweryListSearchChanged>(
      _onSearchChanged,
      transformer: _debounceRestartable(),
    );
    on<BreweryListSearchCleared>(_onSearchCleared);
    scrollController.addListener(_onScroll);
  }

  final GetBreweriesUseCase _getBreweries;
  final SearchBreweriesUseCase _searchBreweries;

  final TextEditingController searchController;
  final ScrollController scrollController;

  CancelToken? _cancelToken;
  int _currentPage = 0;
  bool _isSearchMode = false;
  static const int _perPage = 20;

  Future<void> _onStarted(
    BreweryListStarted event,
    Emitter<BreweryListState> emit,
  ) async {
    await _loadFirstPage(emit, query: '');
  }

  Future<void> _onRetried(
    BreweryListRetried event,
    Emitter<BreweryListState> emit,
  ) async {
    await _loadFirstPage(emit, query: state.query);
  }

  Future<void> _onLoadMore(
    BreweryListLoadMoreRequested event,
    Emitter<BreweryListState> emit,
  ) async {
    final current = state;
    if (current is! BreweryListSuccess ||
        !current.hasMore ||
        current.isLoadingMore ||
        _isSearchMode) {
      return;
    }

    emit(current.copyWith(isLoadingMore: true));
    _replaceCancelToken();

    try {
      final nextPage = _currentPage + 1;
      final pageItems = await _getBreweries(
        page: nextPage,
        perPage: _perPage,
        cancelToken: _cancelToken,
      );
      _currentPage = nextPage;
      emit(
        BreweryListSuccess(
          breweries: [...current.breweries, ...pageItems],
          hasMore: pageItems.length >= _perPage,
          isLoadingMore: false,
          query: current.query,
        ),
      );
    } on DioException catch (error) {
      if (error.type == DioExceptionType.cancel) {
        return;
      }
      emit(current.copyWith(isLoadingMore: false));
    } on BreweryException {
      emit(current.copyWith(isLoadingMore: false));
    }
  }

  Future<void> _onSearchChanged(
    BreweryListSearchChanged event,
    Emitter<BreweryListState> emit,
  ) async {
    final query = event.query.trim();
    if (query.isEmpty) {
      _isSearchMode = false;
      await _loadFirstPage(emit, query: '');
      return;
    }

    _isSearchMode = true;
    emit(BreweryListLoading(query: query));
    _replaceCancelToken();

    try {
      final results = await _searchBreweries(
        query: query,
        cancelToken: _cancelToken,
      );
      if (results.isEmpty) {
        emit(BreweryListEmpty(query: query));
        return;
      }
      emit(
        BreweryListSuccess(
          breweries: results,
          hasMore: false,
          isLoadingMore: false,
          query: query,
        ),
      );
    } on DioException catch (error) {
      if (error.type == DioExceptionType.cancel) {
        return;
      }
      emit(
        BreweryListFailure(
          message: 'No se pudo completar la búsqueda.',
          query: query,
        ),
      );
    } on BreweryException catch (error) {
      emit(
        BreweryListFailure(
          message: error.message,
          query: query,
        ),
      );
    }
  }

  Future<void> _onSearchCleared(
    BreweryListSearchCleared event,
    Emitter<BreweryListState> emit,
  ) async {
    searchController.clear();
    _isSearchMode = false;
    await _loadFirstPage(emit, query: '');
  }

  Future<void> _loadFirstPage(
    Emitter<BreweryListState> emit, {
    required String query,
  }) async {
    emit(BreweryListLoading(query: query));
    _replaceCancelToken();
    _currentPage = 1;
    _isSearchMode = query.isNotEmpty;

    try {
      final items = query.isEmpty
          ? await _getBreweries(
              page: _currentPage,
              perPage: _perPage,
              cancelToken: _cancelToken,
            )
          : await _searchBreweries(
              query: query,
              cancelToken: _cancelToken,
            );
      if (items.isEmpty) {
        emit(BreweryListEmpty(query: query));
        return;
      }
      emit(
        BreweryListSuccess(
          breweries: items,
          hasMore: query.isEmpty && items.length >= _perPage,
          isLoadingMore: false,
          query: query,
        ),
      );
    } on DioException catch (error) {
      if (error.type == DioExceptionType.cancel) {
        return;
      }
      emit(
        BreweryListFailure(
          message: 'No se pudo cargar la lista.',
          query: query,
        ),
      );
    } on BreweryException catch (error) {
      emit(
        BreweryListFailure(
          message: error.message,
          query: query,
        ),
      );
    }
  }

  void _replaceCancelToken() {
    _cancelToken?.cancel();
    _cancelToken = CancelToken();
  }

  void _onScroll() {
    if (!scrollController.hasClients) {
      return;
    }
    final position = scrollController.position;
    if (position.pixels >= position.maxScrollExtent - 200) {
      add(const BreweryListLoadMoreRequested());
    }
  }

  @override
  Future<void> close() {
    _cancelToken?.cancel();
    scrollController.removeListener(_onScroll);
    scrollController.dispose();
    searchController.dispose();
    return super.close();
  }
}
