import 'package:brewery_explorer/core/di/injection.dart';
import 'package:brewery_explorer/features/breweries/presentation/app/app_factories.dart';
import 'package:brewery_explorer/features/breweries/presentation/app/brewery_app.dart';
import 'package:flutter/widgets.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();

  final factories = AppFactories(
    createListBloc: () => getIt(),
    createDetailCubit: () => getIt(),
  );

  runApp(BreweryApp(factories: factories));
}
