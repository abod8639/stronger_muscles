import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stronger_muscles/features/product/data/models/product_model.dart';
import 'package:stronger_muscles/core/utils/components/flavor_image.dart';

import 'package:stronger_muscles/l10n/generated/app_localizations.dart';

FlavorsModel getFlavorDetails(String flavorName) {
  final key = flavorName.toLowerCase().trim();
  final match = flavorsData.keys.firstWhere(
    (k) => key.contains(k),
    orElse: () => "default",
  );

  return flavorsData[match] ??
      FlavorsModel(
        name: flavorName,
        color: Colors.blueGrey,
        image: "https://via.placeholder.com/150",
      );
}

class ProductFlavorSelector extends StatelessWidget {
  final ProductModel product;
  final String selectedFlavor;
  final Function(String) onFlavorSelected;

  const ProductFlavorSelector({
    super.key,
    required this.product,
    required this.selectedFlavor,
    required this.onFlavorSelected,
  });

  @override
  Widget build(BuildContext context) {
    final flavorsList = product.flavors;
    if (flavorsList.isEmpty) return const SizedBox.shrink();

    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n?.chooseYourFlavor ?? "CHOOSE YOUR FLAVOR",
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
            fontStyle: FontStyle.italic,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 10,
          runSpacing: 12,
          children: flavorsList.map((flavor) {
            final isSelected = selectedFlavor == flavor;
            final details = getFlavorDetails(flavor);
            final baseColor = details.color;

            return GestureDetector(
              onTap: () {
                HapticFeedback.lightImpact();
                onFlavorSelected(flavor);
              },
              child: FlavorImage(
                shadow: true,
                isSelected: isSelected,
                baseColor: baseColor,
                details: details,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
