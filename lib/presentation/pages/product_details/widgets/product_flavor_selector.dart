import 'package:flutter/material.dart';
import 'package:stronger_muscles/core/constants/app_colors.dart';
import 'package:stronger_muscles/data/models/product_model.dart';
// قم بتغيير المسارات حسب مشروعك
// import 'package:stronger_muscles/data/models/product_model.dart';
// import 'package:stronger_muscles/l10n/generated/app_localizations.dart';

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
    if (f.contains('banana')) return Colors.yellow.shade600;
    if (f.contains('cookies')) return Colors.grey.shade400;
    if (f.contains('cola')) return Colors.brown.shade600;
    return Colors.grey.shade400;
  }

  @override
  Widget build(BuildContext context) {
    final flavorsList = product.flavors ?? [];
    if (flavorsList.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Select Flavor", // AppLocalizations.of(context)!.selectFlavor
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12.0,
          runSpacing: 12.0,
          // إضافة <Widget> هنا تحل مشكلة الـ TypeError
          children: flavorsList.map<Widget>((flavor) {
            final isSelected = selectedFlavor == flavor;
            final flavorColor = _getFlavorColor(flavor);

            return GestureDetector(
              onTap: () => onFlavorSelected(flavor),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                padding:  EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: isSelected ? 13 : 10,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected ? flavorColor : AppColors.primary,
                    width: 2,
                  ),
                  gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          // هذه القيم تصنع شكل الخطوط المائلة (Zebra Stripes)
                          stops: const [
                            0.0,
                            0.25,
                            0.25,
                            0.5,
                            0.5,
                            0.75,
                            0.75,
                            1.0,
                          ],
                          colors: [
                            flavorColor,
                            flavorColor,
                            flavorColor.withOpacity(0.4),
                            flavorColor.withOpacity(0.4),
                            flavorColor,
                            flavorColor,
                            flavorColor.withOpacity(0.4),
                            flavorColor.withOpacity(0.4),
                          ],
                          tileMode: TileMode.repeated,
                        ),
                     
                  color: isSelected ? flavorColor : flavorColor.withAlpha(50),
                ),
                child: Text(
                  flavor,
                  style: TextStyle(
                    color: isSelected ? Colors.black : Colors.white,
                    fontSize:isSelected? 18:16,
                    fontWeight: isSelected
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
