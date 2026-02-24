import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stronger_muscles/core/constants/app_colors.dart';
import 'package:stronger_muscles/data/models/product_model.dart';

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
    if (f.contains('straw')) return Colors.pinkAccent;
    if (f.contains('choco')) return Colors.brown.shade700;
    if (f.contains('mango')) return Colors.orangeAccent;
    if (f.contains('caramel')) return Colors.amber.shade800;
    if (f.contains('cookies')) return Colors.grey.shade600;
    if (f.contains('banana')) return Colors.yellow.shade800;
    if (f.contains('berry')) return Colors.red.shade800;
    if (f.contains('peanut')) return Colors.orange.shade800;
    if (f.contains('coffee')) return Colors.brown.shade700;
    if (f.contains('mint')) return Colors.green.shade800;
    if (f.contains('cola')) return Colors.brown.shade900;
    return Colors.blueGrey;
  }

  @override
  Widget build(BuildContext context) {
    final flavorsList = product.flavors;
    if (flavorsList.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "CHOOSE YOUR FLAVOR",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
            fontStyle: FontStyle.italic,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 5,
          runSpacing: 10,
          children: flavorsList.map((flavor) {
            final isSelected = selectedFlavor == flavor;
            final baseColor = _getFlavorColor(flavor);

            return GestureDetector(
              onTap: () {
                HapticFeedback.mediumImpact();
                onFlavorSelected(flavor);
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 120,
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isSelected ? baseColor : AppColors.greyMedium,
                    width: 2.5,
                  ),
                  // (Stripped Pattern)
                  gradient: LinearGradient(
                    begin: const Alignment(-1.0, -1.0),
                    end: const Alignment(1.0, 1.0),
                    stops: const [
                      0.0,
                      0.2,
                      0.2,
                      0.4,
                      0.4,
                      0.6,
                      0.6,
                      0.8,
                      0.8,
                      1.0,
                    ],
                    colors: [
                      isSelected ? baseColor : baseColor,
                      isSelected ? baseColor : baseColor,
                      isSelected
                          ? baseColor.withOpacity(0.8)
                          : Colors.grey.shade400,
                      isSelected
                          ? baseColor.withOpacity(0.8)
                          : Colors.grey.shade400,
                      isSelected ? baseColor : AppColors.grey,
                      isSelected ? baseColor : AppColors.grey,
                      isSelected
                          ? baseColor.withOpacity(0.8)
                          : Colors.grey.shade400,
                      isSelected
                          ? baseColor.withOpacity(0.8)
                          : Colors.grey.shade400,
                      isSelected ? baseColor : AppColors.grey,
                      isSelected ? baseColor : AppColors.grey,
                    ],
                  ),
                ),
                child: Stack(
                  children: [
                    Center(
                      child: Text(
                        flavor.toUpperCase(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black,
                          fontWeight: FontWeight.w900,
                          fontSize: 14,
                          shadows: isSelected
                              ? [
                                  Shadow(
                                    blurRadius: 2,
                                    color: Colors.black,
                                    offset: Offset(1, 1),
                                  ),
                                ]
                              : [
                                  Shadow(
                                    blurRadius: 1,
                                    color: baseColor.withAlpha(150),
                                    offset: Offset(1, 1),
                                  ),
                                ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
