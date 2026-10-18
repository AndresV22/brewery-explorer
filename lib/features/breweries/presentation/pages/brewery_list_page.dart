import 'package:brewery_explorer/features/breweries/presentation/app/app_factories.dart';
import 'package:brewery_explorer/features/breweries/presentation/controllers/brewery_list_bloc.dart';
import 'package:brewery_explorer/features/breweries/presentation/controllers/brewery_list_state.dart';
import 'package:brewery_explorer/features/breweries/presentation/handlers/on_brewery_list_retry_handler.dart';
import 'package:brewery_explorer/features/breweries/presentation/handlers/on_brewery_tap_handler.dart';
import 'package:brewery_explorer/features/breweries/presentation/widgets/brewery_list_tile.dart';
import 'package:brewery_explorer/features/breweries/presentation/widgets/loading_view.dart';
import 'package:brewery_explorer/features/breweries/presentation/widgets/status_message_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BreweryListPage extends StatelessWidget {
  const BreweryListPage({
    required this.factories,
    super.key,
  });

  final AppFactories factories;

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<BreweryListBloc>();
    final onRetry = OnBreweryListRetryHandler(bloc);
    final onBreweryTap = OnBreweryTapHandler(
      context: context,
      factories: factories,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Breweries'),
      ),
      body: BlocBuilder<BreweryListBloc, BreweryListState>(
        builder: (context, state) {
          return switch (state) {
            BreweryListInitial() || BreweryListLoading() =>
              const LoadingView(),
            BreweryListEmpty() => const StatusMessageView(
                message: 'No hay cervecerías para mostrar.',
              ),
            BreweryListFailure(:final message) => StatusMessageView(
                message: message,
                actionLabel: 'Reintentar',
                onAction: onRetry.call,
              ),
            BreweryListSuccess(
              :final breweries,
              :final isLoadingMore,
            ) =>
              ListView.separated(
                controller: bloc.scrollController,
                itemCount: breweries.length + (isLoadingMore ? 1 : 0),
                separatorBuilder: (_, _) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  if (index >= breweries.length) {
                    return const Padding(
                      padding: EdgeInsets.all(16),
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }
                  final brewery = breweries[index];
                  return BreweryListTile(
                    brewery: brewery,
                    onTap: () => onBreweryTap(brewery.id),
                  );
                },
              ),
          };
        },
      ),
    );
  }
}
