import 'package:brewery_explorer/features/breweries/presentation/app/app_factories.dart';
import 'package:brewery_explorer/features/breweries/presentation/controllers/brewery_list_event.dart';
import 'package:brewery_explorer/features/breweries/presentation/pages/brewery_list_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BreweryApp extends StatelessWidget {
  const BreweryApp({
    required this.factories,
    super.key,
  });

  final AppFactories factories;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Brewery Explorer',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.brown),
        useMaterial3: true,
      ),
      home: BlocProvider(
        create: (_) => factories.createListBloc()
          ..add(const BreweryListStarted()),
        child: BreweryListPage(factories: factories),
      ),
    );
  }
}
