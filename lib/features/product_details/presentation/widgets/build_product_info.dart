import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stronger_muscles/core/constants/app_colors.dart';
import 'package:stronger_muscles/features/product/data/models/product_model.dart';
import 'package:stronger_muscles/features/search/presentation/controllers/product_search_controller.dart';
import 'package:stronger_muscles/l10n/generated/app_localizations.dart';
import 'package:stronger_muscles/routes/routes.dart';

Widget buildProductInfo(
  ProductModel product,
  bool isDark,
  BuildContext context,
  WidgetRef ref,
) {
  final theme = Theme.of(context);
  final infoItems = <Widget>[];

  void navigateToBrandPage(String brandName) {
    final searchNotifier = ref.read(productSearchControllerProvider.notifier);

    searchNotifier.clearSearch();
    searchNotifier.textController.text = brandName;
    searchNotifier.updateSearchQuery(brandName);

    context.push(AppRoutes.search);
  }

  // Brand
  if (product.brand != null && product.brand!.isNotEmpty) {
    infoItems.add(
      Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 1,
              child: Text(
                AppLocalizations.of(context)!.brand,
                style: TextStyle(
                  fontSize: 14,
                  color: isDark ? AppColors.white : AppColors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Expanded(
              flex: 8,
              child: TextButton(
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                onPressed: () => navigateToBrandPage(product.brand!),
                child: Text(
                  product.brand!,
                  style: TextStyle(
                    fontSize: 14,
                    color: isDark ? AppColors.info : AppColors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
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
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [
                  theme.colorScheme.surface,
                  theme.colorScheme.surface..withValues(alpha: .8),
                ]
              : [
                  theme.colorScheme.surface,
                  theme.colorScheme.primaryContainer..withValues(alpha: .1),
                ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.primary..withValues(alpha: .2),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary..withValues(alpha: .08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
        
        child: Column(children: infoItems),
      ),
    ],
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
