import 'package:flutter/material.dart';
import 'package:stronger_muscles/core/components/components.dart';
import 'package:stronger_muscles/core/constants/app_dimens.dart';
import 'package:stronger_muscles/core/theme/theme.dart';
import 'package:stronger_muscles/features/cart/domain/entities/cart_item_entity.dart';
import 'package:stronger_muscles/l10n/generated/app_localizations.dart';

/// Brand, name and selected variants (flavor / size) of a cart item.
class CartItemDetails extends StatelessWidget {
  final CartItemEntity item;

  const CartItemDetails({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final textTheme = context.textTheme;
    final brand = item.product.brand;
    final flavor = item.selectedFlavor;
    final size = item.selectedSize;
    final productName = item.product.getLocalizedName(locale: l10n.localeName);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (brand != null && brand.isNotEmpty)
          Text(
            brand.toUpperCase(),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: textTheme.bodySmall?.copyWith(
              color: context.colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.6,
            ),
          ),
        Text(
          productName,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: textTheme.titleMedium?.copyWith(
            fontSize: 15.0,
            fontWeight: FontWeight.bold,
            height: 1.3,
            color: context.colorScheme.onSurface,
          ),
        ),
        if ((flavor?.isNotEmpty ?? false) || (size?.isNotEmpty ?? false)) ...[
          const SizedBox(height: AppDimens.spacingSm),
          Wrap(
            spacing: AppDimens.spacingXs,
            runSpacing: AppDimens.spacingXs,
            children: [
              if (flavor != null && flavor.isNotEmpty)
                _VariantChip(label: '${l10n.flavor}: $flavor'),
              if (size != null && size.isNotEmpty)
                _VariantChip(label: '${l10n.size}: $size'),
            ],
          ),
        ],
      ],
    );
  }
}

class _VariantChip extends StatelessWidget {
  final String label;

  const _VariantChip({required this.label});

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme.onSurfaceVariant;

    return AppBadge(
      label: label,
      color: color,
      alpha: 0.08,
      border: Border.all(color: color.withValues(alpha: 0.15)),
      borderRadius: AppRadius.allPill,
      textStyle: context.textTheme.bodySmall?.copyWith(
        color: context.colorScheme.onSurface,
        fontWeight: FontWeight.w600,
        fontSize: 11.0,
      ),
    );
  }
}
