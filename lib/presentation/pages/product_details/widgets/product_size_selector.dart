import 'package:flutter/material.dart';
import 'package:stronger_muscles/data/models/product_model.dart';
import 'package:stronger_muscles/l10n/generated/app_localizations.dart';

class ProductSizeSelector extends StatefulWidget {
  final ProductModel product;
  final String? initialSize;
  final Function(String) onSizeSelected;

  const ProductSizeSelector({
    super.key,
    required this.product,
    this.initialSize,
    required this.onSizeSelected,
  });

  @override
  State<ProductSizeSelector> createState() => _ProductSizeSelectorState();
}

class _ProductSizeSelectorState extends State<ProductSizeSelector> {
  late String? _selectedSize;

  @override
  void initState() {
    super.initState();
    _selectedSize = widget.initialSize;
  }

  @override
  void didUpdateWidget(ProductSizeSelector oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialSize != oldWidget.initialSize) {
      _selectedSize = widget.initialSize;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Priority for productSizes, fallback to size
    final productSizes = widget.product.productSizes;
    final legacySizes = widget.product.size;

    if (productSizes.isEmpty && legacySizes.isEmpty) {
      return const SizedBox.shrink();
    }

    final theme = Theme.of(context);
    final primaryColor = theme.primaryColor;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.size,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8.0,
          runSpacing: 4.0,
          children: productSizes.isNotEmpty
              ? productSizes
                    .map((ps) => _buildChip(ps.size, primaryColor))
                    .toList()
              : legacySizes.map((s) => _buildChip(s, primaryColor)).toList(),
        ),
      ],
    );
  }

  Widget _buildChip(String size, Color primaryColor) {
    final isSelected = _selectedSize == size;

    return ChoiceChip(
      backgroundColor: primaryColor.withOpacity(0.05),
      label: Text(size),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) {
          setState(() {
            _selectedSize = size;
          });
          widget.onSizeSelected(size);
        }
      },
      selectedColor: primaryColor,
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : primaryColor,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: isSelected ? primaryColor : primaryColor.withOpacity(0.3),
          width: isSelected ? 2 : 1,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}
