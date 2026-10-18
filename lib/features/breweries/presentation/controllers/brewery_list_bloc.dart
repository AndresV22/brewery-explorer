import 'package:brewery_explorer/core/errors/brewery_exception.dart';
import 'package:brewery_explorer/features/breweries/domain/use_cases/get_breweries_use_case.dart';
import 'package:brewery_explorer/features/breweries/presentation/controllers/brewery_list_event.dart';
import 'package:brewery_explorer/features/breweries/presentation/controllers/brewery_list_state.dart';
import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class BreweryListBloc extends Bloc<BreweryListEvent, BreweryListState> {
  BreweryListBloc(this._getBreweries)
      : scrollController = ScrollController(),
        super(const BreweryListInitial()) {
    on<BreweryListStarted>(_onStarted);
    on<BreweryListRetried>(_onRetried);
    on<BreweryListLoadMoreRequested>(_onLoadMore);
    scrollController.addListener(_onScroll);
  }

  final GetBreweriesUseCase _getBreweries;
  final ScrollController scrollController;

  CancelToken? _cancelToken;
  int _currentPage = 0;
  static const int _perPage = 20;

  Future<void> _onStarted(
    BreweryListStarted event,
    Emitter<BreweryListState> emit,
  ) async {
    await _loadFirstPage(emit);
  }

  Future<void> _onRetried(
    BreweryListRetried event,
    Emitter<BreweryListState> emit,
  ) async {
    await _loadFirstPage(emit);
  }

  Future<void> _onLoadMore(
    BreweryListLoadMoreRequested event,
    Emitter<BreweryListState> emit,
  ) async {
    final current = state;
    if (current is! BreweryListSuccess ||
        !current.hasMore ||
        current.isLoadingMore) {
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

  Future<void> _loadFirstPage(Emitter<BreweryListState> emit) async {
    emit(const BreweryListLoading());
    _replaceCancelToken();
    _currentPage = 1;

    try {
      final items = await _getBreweries(
        page: _currentPage,
        perPage: _perPage,
        cancelToken: _cancelToken,
      );
      if (items.isEmpty) {
        emit(const BreweryListEmpty());
        return;
      }
      emit(
        BreweryListSuccess(
          breweries: items,
          hasMore: items.length >= _perPage,
          isLoadingMore: false,
        ),
      );
    } on DioException catch (error) {
      if (error.type == DioExceptionType.cancel) {
        return;
      }
      emit(const BreweryListFailure('No se pudo cargar la lista.'));
    } on BreweryException catch (error) {
      emit(BreweryListFailure(error.message));
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
    return super.close();
  }
}
