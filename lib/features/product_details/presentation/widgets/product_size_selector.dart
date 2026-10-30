import 'package:flutter/material.dart';
import 'package:stronger_muscles/core/components/components.dart';
import 'package:stronger_muscles/features/product/product_feature.dart';
import 'package:stronger_muscles/l10n/generated/app_localizations.dart';

/// Size options for a product (falls back to legacy `size` list).
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

    final sizes = productSizes.isNotEmpty ? productSizes.map((ps) => ps.size).toList() : legacySizes;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppFieldLabel(AppLocalizations.of(context)!.size),
        AppChoiceChips<String>(
          scrollable: false,
          items: sizes,
          selected: _selectedSize ?? '',
          labelOf: (size) => size,
          onSelected: (size) {
            setState(() => _selectedSize = size);
            widget.onSizeSelected(size);
          },
        ),
      ],
    );
  }
}
