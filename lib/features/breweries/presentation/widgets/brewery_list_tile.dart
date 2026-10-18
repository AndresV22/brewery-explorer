import 'package:brewery_explorer/features/breweries/domain/entities/brewery.dart';
import 'package:flutter/material.dart';

class BreweryListTile extends StatelessWidget {
  const BreweryListTile({
    required this.brewery,
    required this.onTap,
    super.key,
  });

  final Brewery brewery;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final subtitleParts = <String>[
      brewery.breweryType,
      if (brewery.city != null && brewery.city!.isNotEmpty) brewery.city!,
    ];

    return ListTile(
      title: Text(brewery.name),
      subtitle: Text(subtitleParts.join(' · ')),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
