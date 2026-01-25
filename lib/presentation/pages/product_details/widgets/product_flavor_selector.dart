import 'package:flutter/material.dart';
import 'package:stronger_muscles/data/models/product_model.dart';
import 'package:stronger_muscles/l10n/generated/app_localizations.dart';

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

  Color _getFlavorColor(String flavor) {
    final f = flavor.toLowerCase();
    if (f.contains('vanilla')) return const Color(0xFFF3E5AB);
    if (f.contains('straw')) return Colors.pink.shade300;
    if (f.contains('choco')) return Colors.brown.shade600;
    if (f.contains('mango')) return Colors.orange.shade400;
    if (f.contains('caramel')) return Colors.amber.shade800;
    if (f.contains('coffee')) return Colors.brown.shade800;
    if (f.contains('tot')) return Colors.purple.shade600;
    return Colors.grey.shade400;
  }

  bool _isDarkColor(Color color) => color.computeLuminance() < 0.7;

  @override
  Widget build(BuildContext context) {
    final flavorsList = product.flavors ?? [];
    
    if (flavorsList.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: Text(
            AppLocalizations.of(context)!.selectFlavor,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 10.0,
          runSpacing: 10.0,
          children: flavorsList.map((flavor) {
            final isSelected = selectedFlavor == flavor;
            final flavorColor = _getFlavorColor(flavor);
            final bool isDark = _isDarkColor(flavorColor);

            return ChoiceChip(
              elevation: isSelected ? 4 : 0,
              pressElevation: 2,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              label: Text(flavor),
              selected: isSelected,
              onSelected: (bool selected) {
                if (selected) onFlavorSelected(flavor);
              },
              selectedColor: flavorColor,
              backgroundColor: flavorColor.withOpacity(0.1),
              labelStyle: TextStyle(
                color: isSelected 
                    ? (isDark ? Colors.white : Colors.black) 
                    : Colors.black87,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(
                  color: isSelected ? flavorColor : Colors.grey.shade300,
                  width: isSelected ? 2 : 1,
                ),
              ),
              showCheckmark: false, 
            );
          }).toList(),
        ),
      ],
    );
  }
}