import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stronger_muscles/core/components/components.dart';
import 'package:stronger_muscles/features/product/product_feature.dart';
import 'package:stronger_muscles/l10n/generated/app_localizations.dart';

/// Flavor swatches for a product; uses the shared [getFlavorDetails] lookup.
class ProductFlavorSelector extends StatelessWidget {
  final ProductModel product;
  final String selectedFlavor;
  final Function(String) onFlavorSelected;
  final List<String>? flavors;

  const ProductFlavorSelector({
    super.key,
    required this.product,
    required this.selectedFlavor,
    required this.onFlavorSelected,
    this.flavors,
  });

  @override
  Widget build(BuildContext context) {
    final flavorsList = (flavors != null && flavors!.isNotEmpty)
        ? flavors!
        : product.flavors;
    if (flavorsList.isEmpty) return const SizedBox.shrink();

    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppFieldLabel(
          l10n?.chooseYourFlavor ?? 'Choose your flavor',
          padding: const EdgeInsets.only(bottom: 10.0),
        ),
        Wrap(
          spacing: 10,
          runSpacing: 12,
          children: flavorsList.map((flavor) {
            final details = getFlavorDetails(flavor);
            final isSelected =
                selectedFlavor == details.name || selectedFlavor == flavor;
            final baseColor = details.color;

            return GestureDetector(
              onTap: () {
                HapticFeedback.lightImpact();
                onFlavorSelected(details.name);
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
