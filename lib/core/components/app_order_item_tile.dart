import 'package:flutter/material.dart';
import 'package:stronger_muscles/core/components/app_network_image.dart';
import 'package:stronger_muscles/core/components/app_price_text.dart';
import 'package:stronger_muscles/core/constants/app_colors.dart';
import 'package:stronger_muscles/core/constants/app_dimens.dart';
import 'package:stronger_muscles/core/theme/theme.dart';

/// Compact line item for order summaries: thumbnail, name, optional variant
/// line, `qty × unit price` and the line total.
class AppOrderItemTile extends StatelessWidget {
  final String? imageUrl;
  final String title;
  final String? subtitle;
  final int quantity;
  final double unitPrice;
  final double total;
  final double imageSize;
  final EdgeInsetsGeometry padding;

  const AppOrderItemTile({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.quantity,
    required this.unitPrice,
    required this.total,
    this.subtitle,
    this.imageSize = 52.0,
    this.padding = const EdgeInsets.symmetric(vertical: AppDimens.spacingSm),
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;
    final mutedColor = context.colorScheme.onSurfaceVariant;
    final cacheSize = (imageSize * MediaQuery.devicePixelRatioOf(context)).round();

    return Padding(
      padding: padding,
      child: Row(
        children: [
          AppNetworkImage(
            imageUrl: imageUrl,
            width: imageSize,
            height: imageSize,
            borderRadius: AppRadius.allSm,
            memCacheWidth: cacheSize,
            memCacheHeight: cacheSize,
          ),
          const SizedBox(width: AppDimens.spacingMd),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                ),
                if (subtitle != null && subtitle!.isNotEmpty)
                  Text(
                    subtitle!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.bodySmall?.copyWith(color: mutedColor),
                  ),
                const SizedBox(height: 2.0),
                Text(
                  '$quantity × ${AppPriceText.format(unitPrice)}',
                  style: textTheme.bodySmall?.copyWith(color: mutedColor),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppDimens.spacingSm),
          Text(
            AppPriceText.format(total),
            style: textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}
