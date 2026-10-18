import 'package:brewery_explorer/features/breweries/presentation/controllers/brewery_detail_cubit.dart';
import 'package:brewery_explorer/features/breweries/presentation/controllers/brewery_list_bloc.dart';

class AppFactories {
  const AppFactories({
    required this.createListBloc,
    required this.createDetailCubit,
  });

  final BreweryListBloc Function() createListBloc;
  final BreweryDetailCubit Function() createDetailCubit;
}
