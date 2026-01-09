import 'package:flutter/material.dart';
import 'package:stronger_muscles/data/models/product_model.dart';

class ProductFlavorSelector extends StatefulWidget {
  final ProductModel product;
  final Function(String) onFlavorSelected;

  const ProductFlavorSelector({
    super.key,
    required this.product,
    required this.onFlavorSelected,
  });

  @override
  State<ProductFlavorSelector> createState() => _ProductFlavorSelectorState();
}

class _ProductFlavorSelectorState extends State<ProductFlavorSelector> {
  String? _selectedFlavor;

  @override
  void initState() {
    super.initState();
    // اختيار أول نكهة بشكل تلقائي إذا كانت القائمة غير فارغة
    if (widget.product.flavors != null && widget.product.flavors!.isNotEmpty) {
      _selectedFlavor = widget.product.flavors!.first;
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
        const Text(
          "اختر النكهة:",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8.0,
          runSpacing: 4.0,

          children: flavors.map((flavor) {
            final isSelected = _selectedFlavor == flavor;
            return ChoiceChip(
              backgroundColor: Theme.of(context).colorScheme.surface,
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
              selectedColor: Theme.of(context).primaryColor,
              labelStyle: TextStyle(
                color: isSelected ? Theme.of(context).scaffoldBackgroundColor : Theme.of(context).primaryColor,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
              // backgroundColor: Colors.grey.shade200,
              shape: RoundedRectangleBorder(
                side: BorderSide(
                  color: isSelected ? 
                  Theme.of(context).colorScheme.surface
                  : 
                  Theme.of(context).primaryColor.withOpacity(0.5),
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
