import 'package:flutter/material.dart';
import 'package:stronger_muscles/core/constants/app_colors.dart';
import 'package:stronger_muscles/core/constants/app_dimens.dart';
import 'package:stronger_muscles/core/utils/components/flavor_image.dart';
import 'package:stronger_muscles/features/cart/domain/entities/cart_item_entity.dart';
import 'package:stronger_muscles/features/product_details/presentation/widgets/product_flavor_selector.dart';
import 'package:stronger_muscles/l10n/generated/app_localizations.dart';

const double _titleFontSize = 16.0;
const double _priceFontSize = 15.0;
const int _maxTitleLines = 2;

Widget buildProductCartDetails(CartItemEntity item) {
  return Builder(
    builder: (context) {
      final theme = Theme.of(context);
      final l10n = AppLocalizations.of(context)!;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Brand
          if (item.product.brand != null)
            Text(
              item.product.brand!,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
            ),
          const SizedBox(height: AppDimens.spacingXs),

          // Product Name
          Text(
            item.product.getLocalizedName(locale: l10n.localeName),
            style: theme.textTheme.titleMedium?.copyWith(
              fontSize: _titleFontSize,
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
            maxLines: _maxTitleLines,
            overflow: TextOverflow.ellipsis,
            semanticsLabel: item.product.getLocalizedName(locale: l10n.localeName),
          ),

          // Selected Flavor
          if (item.selectedFlavor != null && item.selectedFlavor!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: AppDimens.spacingXs),
              child: Row(
                children: [
                  selectedValue(
                    title: l10n.flavor,
                    value: item.selectedFlavor!,
                  ),
                  const Spacer(),
                  FlavorImage(
                    shadow: false,
                    width: 75,
                    height: 26,
                    isSelected: false,
                    baseColor: AppColors.primary,
                    details: getFlavorDetails(item.selectedFlavor!),
                  ),
                ],
              ),
            ),

          // Selected Size
          if (item.selectedSize != null && item.selectedSize!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: AppDimens.spacingXs),
              child: selectedValue(
                title: l10n.size,
                value: item.selectedSize!,
              ),
            ),

          const SizedBox(height: AppDimens.spacingSm),

          // Product Price
          Row(
            children: [
              Text(
                'LE ${item.product.baseEffectivePrice.toStringAsFixed(2)}',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontSize: _priceFontSize,
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: AppDimens.spacingSm),
              if (item.product.baseHasDiscount)
                Text(
                  'LE ${item.product.basePrice.toStringAsFixed(2)}',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontSize: _priceFontSize,
                    color: AppColors.grey,
                    fontWeight: FontWeight.w600,
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
            ],
          ),

          // Total Price (if quantity > 1)
          if (item.quantity > 1)
            Padding(
              padding: const EdgeInsets.only(top: AppDimens.spacingXs),
              child: Text(
                '${l10n.total}: LE ${item.subtotal.toStringAsFixed(2)}',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
        ],
      );
    },
  );
}

Widget selectedValue({
  required String title,
  required String value,
  Color? color,
}) {
  return Builder(
    builder: (context) {
      final theme = Theme.of(context);
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "$title: ",
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            value,
            style: theme.textTheme.bodySmall?.copyWith(
              color: color ?? AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      );
    },
  );
}
