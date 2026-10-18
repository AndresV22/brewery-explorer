import 'package:brewery_explorer/core/errors/brewery_exception.dart';
import 'package:brewery_explorer/features/breweries/domain/use_cases/get_brewery_by_id_use_case.dart';
import 'package:brewery_explorer/features/breweries/presentation/controllers/brewery_detail_state.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class BreweryDetailCubit extends Cubit<BreweryDetailState> {
  BreweryDetailCubit(this._getBreweryById)
      : super(const BreweryDetailInitial());

  final GetBreweryByIdUseCase _getBreweryById;
  CancelToken? _cancelToken;
  String? _breweryId;

  String? get breweryId => _breweryId;

  Future<void> load(String id) async {
    _breweryId = id;
    emit(const BreweryDetailLoading());
    _cancelToken?.cancel();
    _cancelToken = CancelToken();

    try {
      final brewery = await _getBreweryById(
        id,
        cancelToken: _cancelToken,
      );
      emit(BreweryDetailSuccess(brewery));
    } on DioException catch (error) {
      if (error.type == DioExceptionType.cancel) {
        return;
      }
      emit(const BreweryDetailFailure('No se pudo cargar el detalle.'));
    } on BreweryException catch (error) {
      emit(BreweryDetailFailure(error.message));
    }
  }

  @override
  Future<void> close() {
    _cancelToken?.cancel();
    return super.close();
  }
}
