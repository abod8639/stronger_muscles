// [Certain]
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
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
  final l10n = AppLocalizations.of(context)!;
  final locale = Localizations.localeOf(context).languageCode;
  final infoItems = <Widget>[];

  // دالة الملاحة للبراند
  void navigateToBrandPage(String brandName) {
    final searchNotifier = ref.read(productSearchControllerProvider.notifier);
    searchNotifier.clearSearch();
    searchNotifier.textController.text = brandName;
    searchNotifier.updateSearchQuery(brandName);
    context.push(AppRoutes.search , extra: false);
  }

  final dataMap = [
    if (product.brand?.isNotEmpty ?? false)
      {'label': l10n.brand, 'value': product.brand!, 'isLink': true},
    if (product.category?.name != null)
      {'label': l10n.category, 'value': product.category!.getLocalizedName(locale: locale)},
    if (product.sku != null) 
      {'label': l10n.sku, 'value': product.sku!},
    if (product.servingSize != null) 
      {'label': l10n.servingSize, 'value': product.servingSize!},
    {'label': l10n.servingsPerContainer, 'value': '${product.servingsPerContainer}'},
    if (product.weight != null) 
      {'label': l10n.weight, 'value': '${product.weight} كجم'},
    if (product.manufacturer != null) 
      {'label': l10n.manufacturer, 'value': product.manufacturer!},
    if (product.countryOfOrigin != null) 
      {'label': l10n.countryOfOrigin, 'value': product.countryOfOrigin!},
  ];

  for (var i = 0; i < dataMap.length; i++) {
    final item = dataMap[i];
    infoItems.add(
      _buildInfoRow(
        label: item['label'] as String,
        value: item['value'] as String,
        isDark: isDark,
        isLink: item['isLink'] == true,
        onTap: item['isLink'] == true ? () => navigateToBrandPage(item['value'] as String) : null,
      ),
    );
    if (i < dataMap.length - 1) {
      infoItems.add(Divider(color: AppColors.primary.withValues(alpha: 0.1), height: 16));
    }
  }

  if (infoItems.isEmpty) return const SizedBox.shrink();

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
        child: Text(
          l10n.productInfo,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: isDark ? AppColors.white : AppColors.black,
          ),
        ),
      ),
      Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? theme.colorScheme.surface : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: AppColors.primary.withValues(alpha: 0.15),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(children: infoItems),
      ),
    ],
  );
}

Widget _buildInfoRow({
  required String label,
  required String value,
  required bool isDark,
  bool isLink = false,
  VoidCallback? onTap,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 4,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 16,
              color: isDark ? Colors.grey[400] : Colors.grey[600],
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          flex: 6,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(4),
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: TextStyle(
                fontSize: 14,
                color: isLink 
                    ? AppColors.info 
                    : (isDark ? AppColors.white : AppColors.black),
                fontWeight: isLink ? FontWeight.bold : FontWeight.w600,
                // decoration: isLink ? TextDecoration.underline : null,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}