import 'package:brewery_explorer/core/routing/app_navigator.dart';
import 'package:brewery_explorer/features/breweries/presentation/app/app_factories.dart';
import 'package:brewery_explorer/features/breweries/presentation/pages/brewery_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OnBreweryTapHandler {
  const OnBreweryTapHandler({
    required this.context,
    required this.factories,
  });

  final BuildContext context;
  final AppFactories factories;

  Future<void> call(String breweryId) async {
    await AppNavigator.push(
      context,
      BlocProvider(
        create: (_) => factories.createDetailCubit()..load(breweryId),
        child: const BreweryDetailPage(),
      ),
    );
  }
}
