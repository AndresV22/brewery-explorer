import 'package:brewery_explorer/features/breweries/presentation/controllers/brewery_list_bloc.dart';
import 'package:brewery_explorer/features/breweries/presentation/controllers/brewery_list_event.dart';

class OnBrewerySearchChangedHandler {
  const OnBrewerySearchChangedHandler(this._bloc);

  final BreweryListBloc _bloc;

  void call(String query) {
    _bloc.add(BreweryListSearchChanged(query));
  }
}
