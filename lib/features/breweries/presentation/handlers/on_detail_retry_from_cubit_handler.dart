import 'package:brewery_explorer/features/breweries/presentation/controllers/brewery_detail_cubit.dart';

class OnDetailRetryFromCubitHandler {
  const OnDetailRetryFromCubitHandler(this._cubit);

  final BreweryDetailCubit _cubit;

  Future<void> call() async {
    final id = _cubit.breweryId;
    if (id == null) {
      return;
    }
    await _cubit.load(id);
  }
}
