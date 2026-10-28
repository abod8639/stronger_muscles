import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:stronger_muscles/core/components/app_card.dart';
import 'package:stronger_muscles/core/components/app_info_row.dart';
import 'package:stronger_muscles/core/constants/app_colors.dart';
import 'package:stronger_muscles/core/constants/app_dimens.dart';
import 'package:stronger_muscles/core/theme/app_radius.dart';
import 'package:stronger_muscles/core/theme/app_shadows.dart';
import 'package:stronger_muscles/features/product/product_feature.dart';
import 'package:stronger_muscles/features/search/search_feature.dart';
import 'package:stronger_muscles/l10n/generated/app_localizations.dart';
import 'package:stronger_muscles/routes/routes.dart';

Widget buildProductInfo(
  ProductModel product,
  bool isDark,
  BuildContext context,
  WidgetRef ref,
) {
  final l10n = AppLocalizations.of(context)!;
  final locale = Localizations.localeOf(context).languageCode;
  final infoItems = <Widget>[];

  // Navigation callback for brand
  void navigateToBrandPage(String brandName) {
    final searchNotifier = ref.read(productSearchControllerProvider.notifier);
    searchNotifier.clearSearch();
    searchNotifier.textController.text = brandName;
    searchNotifier.updateSearchQuery(brandName);
    context.push(AppRoutes.search, extra: false);
  }

  final dataMap = [
    if (product.brand?.isNotEmpty ?? false)
      {'label': l10n.brand, 'value': product.brand!, 'isLink': true},
    if (product.category?.name != null)
      {
        'label': l10n.category,
        'value': product.category!.getLocalizedName(locale: locale),
      },
    if (product.sku != null) {'label': l10n.sku, 'value': product.sku!},
    if (product.servingSize != null)
      {'label': l10n.servingSize, 'value': product.servingSize!},
    {
      'label': l10n.servingsPerContainer,
      'value': '${product.servingsPerContainer}',
    },
    if (product.weight != null)
      {'label': l10n.weight, 'value': '${product.weight} ${l10n.kg}'},
    if (product.manufacturer != null)
      {'label': l10n.manufacturer, 'value': product.manufacturer!},
    if (product.countryOfOrigin != null)
      {'label': l10n.countryOfOrigin, 'value': product.countryOfOrigin!},
  ];

  for (var i = 0; i < dataMap.length; i++) {
    final item = dataMap[i];
    final isLink = item['isLink'] == true;
    final valueStr = item['value'] as String;

    infoItems.add(
      AppInfoRow(
        label: item['label'] as String,
        value: valueStr,
        labelStyle: TextStyle(
          fontSize: 16,
          color: isDark ? Colors.grey[400] : Colors.grey[600],
          fontWeight: FontWeight.w600,
        ),
        valueStyle: TextStyle(
          fontSize: 14,
          color: isLink
              ? AppColors.info
              : (isDark ? AppColors.white : AppColors.black),
          fontWeight: isLink ? FontWeight.bold : FontWeight.w600,
        ),
        valueWidget: isLink
            ? InkWell(
                onTap: () => navigateToBrandPage(valueStr),
                borderRadius: AppRadius.allXs,
                child: Text(
                  valueStr,
                  textAlign: TextAlign.end,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.info,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            : null,
      ),
    );

    if (i < dataMap.length - 1) {
      infoItems.add(
        Divider(
          color: AppColors.primary.withValues(alpha: 0.1),
          height: 16,
        ),
      );
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
      AppCard(
        padding: const EdgeInsets.all(AppDimens.spacingLg),
        borderRadius: AppRadius.allLg,
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.15),
          width: 1,
        ),
        boxShadow: AppShadows.ofSubtle(context),
        child: Column(children: infoItems),
      ),
    ],
  );
}