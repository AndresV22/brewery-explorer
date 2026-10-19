import 'package:brewery_explorer/features/breweries/presentation/controllers/brewery_list_bloc.dart';
import 'package:brewery_explorer/features/breweries/presentation/controllers/brewery_list_event.dart';

class OnBrewerySearchClearedHandler {
  const OnBrewerySearchClearedHandler(this._bloc);

  final BreweryListBloc _bloc;

  void call() {
    _bloc.add(const BreweryListSearchCleared());
  }
}
