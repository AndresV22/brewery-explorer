import 'package:flutter/material.dart';

class BrewerySearchField extends StatelessWidget {
  const BrewerySearchField({
    required this.controller,
    required this.onChanged,
    required this.onClear,
    super.key,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      textInputAction: TextInputAction.search,
      decoration: InputDecoration(
        hintText: 'Buscar cervecerías',
        prefixIcon: const Icon(Icons.search),
        suffixIcon: ValueListenableBuilder<TextEditingValue>(
          valueListenable: controller,
          builder: (context, value, _) {
            if (value.text.isEmpty) {
              return const SizedBox.shrink();
            }
            return IconButton(
              icon: const Icon(Icons.clear),
              onPressed: onClear,
            );
          },
        ),
        border: const OutlineInputBorder(),
        isDense: true,
      ),
    );
  }
}
