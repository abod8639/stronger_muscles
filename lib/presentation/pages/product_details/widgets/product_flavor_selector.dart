import 'package:flutter/material.dart';
import 'package:stronger_muscles/data/models/product_model.dart';
import 'package:stronger_muscles/l10n/generated/app_localizations.dart';

class ProductFlavorSelector extends StatefulWidget {
  final ProductModel product;
  final String? initialFlavor;
  final Function(String) onFlavorSelected;

  const ProductFlavorSelector({
    super.key,
    required this.product,
    this.initialFlavor,
    required this.onFlavorSelected,
  });

  @override
  State<ProductFlavorSelector> createState() => _ProductFlavorSelectorState();
}

class _ProductFlavorSelectorState extends State<ProductFlavorSelector> {
  String? _selectedFlavor;

  Color _getFlavorColor(String flavor) {
    switch (flavor.toLowerCase()) {
      case 'vanilla':
        return const Color(0xFFF3E5AB); // Creamy yellow
      case 'strawberry':
        return Colors.pink.shade300;
      case 'choco':
        return Colors.brown.shade600;
      case 'mango':
        return Colors.orange.shade400;
      case 'caramel':
        return Colors.amber.shade800;
      case 'coffee':
        return Colors.brown.shade800;
      case 'vanilla cream':
        return const Color(0xFFFDF5E6); // Old Lace / Cream
      case 'tot':
        return Colors.purple.shade600;
      case 'no flavor':
        return Colors.grey.shade400;
      default:
        return Colors.grey.shade200;
    }
  }

  bool _isDarkColor(Color color) {
    return color.computeLuminance() < 0.5;
  }

  @override
  void initState() {
    super.initState();
    _selectedFlavor =
        widget.initialFlavor ??
        (widget.product.flavors?.isNotEmpty == true
            ? widget.product.flavors!.first
            : null);
  }

  @override
  void didUpdateWidget(ProductFlavorSelector oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialFlavor != oldWidget.initialFlavor) {
      _selectedFlavor = widget.initialFlavor;
    }
  }

  @override
  Widget build(BuildContext context) {
    final flavors = widget.product.flavors;
    if (flavors == null || flavors.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.selectFlavor,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8.0,
          runSpacing: 4.0,
          children: flavors.map((flavor) {
            final isSelected = _selectedFlavor == flavor;
            final flavorColor = _getFlavorColor(flavor);
            final textColor = isSelected
                ? (_isDarkColor(flavorColor) ? Colors.white : Colors.black)
                : (_isDarkColor(flavorColor) ? flavorColor : Colors.black87);

            return ChoiceChip(
              backgroundColor: flavorColor.withOpacity(0.15),
              label: Text(flavor),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) {
                  setState(() {
                    _selectedFlavor = flavor;
                  });
                  widget.onFlavorSelected(flavor);
                }
              },
              selectedColor: flavorColor,
              labelStyle: TextStyle(
                color: textColor,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
              shape: RoundedRectangleBorder(
                side: BorderSide(
                  color: isSelected
                      ? flavorColor
                      : flavorColor.withOpacity(0.5),
                  width: isSelected ? 2 : 1,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
