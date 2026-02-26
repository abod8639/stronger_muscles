import 'package:flutter/material.dart';
import 'package:stronger_muscles/core/constants/app_colors.dart';
import 'package:stronger_muscles/data/models/product_model.dart';
import 'package:stronger_muscles/l10n/generated/app_localizations.dart';

Widget buildProductInfo(
  ProductModel product,
  bool isDark,
  BuildContext context,
) {
  final infoItems = <Widget>[];

  // Brand
  if (product.brand != null && product.brand!.isNotEmpty) {
    infoItems.add(
      _buildInfoRow(
        AppLocalizations.of(context)!.brand,
        product.brand!,
        isDark,
      ),
    );
  }

  // Category
  if (product.category != null && product.category!.name != null) {
    final locale = Localizations.localeOf(context).languageCode;
    infoItems.add(
      _buildInfoRow(
        AppLocalizations.of(context)!.category,
        product.category!.getLocalizedName(locale: locale),
        isDark,
      ),
    );
  }

  // SKU
  if (product.sku != null) {
    infoItems.add(
      _buildInfoRow(AppLocalizations.of(context)!.sku, product.sku!, isDark),
    );
  }

  // Serving Size
  if (product.servingSize != null) {
    infoItems.add(
      _buildInfoRow(
        AppLocalizations.of(context)!.servingSize,
        product.servingSize!,
        isDark,
      ),
    );
  }

  // Servings Per Container
  infoItems.add(
    _buildInfoRow(
      AppLocalizations.of(context)!.servingsPerContainer,
      '${product.servingsPerContainer}',
      isDark,
    ),
  );

  // Weight
  if (product.weight != null) {
    infoItems.add(
      _buildInfoRow(
        AppLocalizations.of(context)!.weight,
        '${product.weight} كجم',
        isDark,
      ),
    );
  }

  // Manufacturer
  if (product.manufacturer != null) {
    infoItems.add(
      _buildInfoRow(
        AppLocalizations.of(context)!.manufacturer,
        product.manufacturer!,
        isDark,
      ),
    );
  }

  // Country of Origin
  if (product.countryOfOrigin != null) {
    infoItems.add(
      _buildInfoRow(
        AppLocalizations.of(context)!.countryOfOrigin,
        product.countryOfOrigin!,
        isDark,
      ),
    );
  }

  if (infoItems.isEmpty) return const SizedBox.shrink();

  return Builder(
    builder: (context) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.productInfo,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDark ? AppColors.white : AppColors.black,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  blurStyle: BlurStyle.outer,
                  color: isDark
                      ? AppColors.greyLight.withOpacity(0.3)
                      : AppColors.surfaceDark.withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
              color: isDark

                  ? AppColors.surfaceDark
                  : AppColors.greyLight.withOpacity(0.3),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(children: infoItems),
          ),
        ],
      );
    },
  );
}

Widget _buildInfoRow(String label, String value, bool isDark) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: isDark ? AppColors.white : AppColors.black,
              //  isDark ? AppColors.grey : AppColors.greyDark,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Text(
            value,
            style: TextStyle(
              fontSize: 14,
              color: isDark ? AppColors.white : AppColors.black,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    ),
  );
}
