import 'package:brewery_explorer/features/breweries/presentation/controllers/brewery_detail_cubit.dart';
import 'package:brewery_explorer/features/breweries/presentation/controllers/brewery_detail_state.dart';
import 'package:brewery_explorer/features/breweries/presentation/handlers/on_detail_retry_from_cubit_handler.dart';
import 'package:brewery_explorer/features/breweries/presentation/handlers/on_phone_tap_handler.dart';
import 'package:brewery_explorer/features/breweries/presentation/handlers/on_website_tap_handler.dart';
import 'package:brewery_explorer/features/breweries/presentation/widgets/loading_view.dart';
import 'package:brewery_explorer/features/breweries/presentation/widgets/status_message_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BreweryDetailPage extends StatelessWidget {
  const BreweryDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<BreweryDetailCubit>();
    final onPhoneTap = const OnPhoneTapHandler();
    final onWebsiteTap = const OnWebsiteTapHandler();
    final onRetry = OnDetailRetryFromCubitHandler(cubit);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle'),
      ),
      body: BlocBuilder<BreweryDetailCubit, BreweryDetailState>(
        builder: (context, state) {
          return switch (state) {
            BreweryDetailInitial() || BreweryDetailLoading() =>
              const LoadingView(),
            BreweryDetailFailure(:final message) => StatusMessageView(
                message: message,
                actionLabel: 'Reintentar',
                onAction: () => onRetry(),
              ),
            BreweryDetailSuccess(:final brewery) => ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Text(
                    brewery.name,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(brewery.breweryType),
                  const SizedBox(height: 16),
                  Text(
                    'Dirección',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    brewery.formattedAddress.isEmpty
                        ? 'Sin dirección'
                        : brewery.formattedAddress,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Teléfono',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 4),
                  if (brewery.phone != null && brewery.phone!.isNotEmpty)
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton(
                        onPressed: () => onPhoneTap(brewery.phone!),
                        child: Text(brewery.phone!),
                      ),
                    )
                  else
                    const Text('Sin teléfono'),
                  const SizedBox(height: 16),
                  Text(
                    'Sitio web',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 4),
                  if (brewery.websiteUrl != null &&
                      brewery.websiteUrl!.isNotEmpty)
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton(
                        onPressed: () => onWebsiteTap(brewery.websiteUrl!),
                        child: Text(brewery.websiteUrl!),
                      ),
                    )
                  else
                    const Text('Sin sitio web'),
                ],
              ),
          };
        },
      ),
    );
  }
}
