import 'package:flutter/material.dart';
import 'package:stronger_muscles/core/constants/app_colors.dart';
import 'package:stronger_muscles/data/models/product_model.dart';
import 'package:stronger_muscles/l10n/generated/app_localizations.dart';

Widget buildIngredientsSection(ProductModel product, bool isDark) {
  if (product.ingredients.isEmpty) return const SizedBox.shrink();

  return Builder(
    builder: (context) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.ingredients,
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
              color: isDark
                  ? AppColors.surfaceDark
                  : AppColors.greyLight.withOpacity(0.3),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: product.ingredients.map((ingredient) {
                return Chip(
                  label: Text(
                    ingredient,
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark ? AppColors.white : AppColors.black,
                    ),
                  ),
                  backgroundColor: isDark
                      ? AppColors.backgroundDark
                      : AppColors.white,
                  side: BorderSide(
                    color: isDark ? AppColors.greyDark : AppColors.grey,
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      );
    },
  );
}
