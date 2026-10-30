import 'package:flutter/material.dart';
import 'package:stronger_muscles/core/components/app_card.dart';
import 'package:stronger_muscles/core/components/app_price_text.dart';
import 'package:stronger_muscles/core/constants/app_colors.dart';
import 'package:stronger_muscles/core/theme/app_radius.dart';
import 'package:stronger_muscles/core/theme/app_shadows.dart';
import 'package:stronger_muscles/features/product/product_feature.dart';
import 'package:stronger_muscles/features/home/home_feature.dart';
import 'package:stronger_muscles/l10n/generated/app_localizations.dart';

/// Reusable product card component built on top of [AppCard] with unified
/// [AppRadius.allLg] and theme-adaptive [AppShadows.ofCard].
///
/// Supports both [ProductModel] and [ProductEntity] through factory constructors.
class AppProductCard extends StatefulWidget {
  const AppProductCard({
    super.key,
    required this.product,
    this.showName = true,
    this.onPageChanged,
    this.onTap,
    this.isBackgroundWhite = false,
    this.query,
  });

  final VoidCallback? onTap;
  final ProductModel product;
  final bool? showName;
  final bool isBackgroundWhite;
  final String? query;
  final ValueChanged<int>? onPageChanged;

  /// Convenient constructor to instantiate from a domain [ProductEntity].
  factory AppProductCard.fromEntity({
    Key? key,
    required ProductEntity entity,
    bool? showName = true,
    ValueChanged<int>? onPageChanged,
    VoidCallback? onTap,
    bool isBackgroundWhite = false,
    String? query,
  }) {
    return AppProductCard(
      key: key,
      product: ProductModel.fromEntity(entity),
      showName: showName,
      onPageChanged: onPageChanged,
      onTap: onTap,
      isBackgroundWhite: isBackgroundWhite,
      query: query,
    );
  }

  @override
  State<AppProductCard> createState() => _AppProductCardState();
}

class _AppProductCardState extends State<AppProductCard>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final isOutOfStock = !widget.product.isInStock;

    return AppCard(
      padding: EdgeInsets.zero,
      borderRadius: AppRadius.allLg,
      boxShadow: AppShadows.ofCard(context),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image Section
          Expanded(flex: 3, child: ImageSection(widget: widget)),

          // Details Section
          if (widget.showName != null && widget.showName == true)
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12.0, 8.0, 12.0, 12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TitleAndDescription(
                      product: widget.product,
                      query: widget.query,
                    ),

                    Wrap(
                      alignment: WrapAlignment.spaceBetween,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 8.0,
                      runSpacing: 4.0,
                      children: [
                        Wrap(
                          spacing: 6,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            Text(
                              AppPriceText.format(widget.product.baseEffectivePrice),
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: isOutOfStock
                                    ? theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.6)
                                    : AppColors.primary,
                                fontWeight: FontWeight.bold,
                                decoration: isOutOfStock
                                    ? TextDecoration.lineThrough
                                    : null,
                              ),
                            ),
                            if (widget.product.baseHasDiscount && !isOutOfStock)
                              Text(
                                AppPriceText.format(widget.product.basePrice),
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: Colors.grey,
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                          ],
                        ),
                        if (isOutOfStock)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6.0,
                              vertical: 2.0,
                            ),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.error.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(4.0),
                              border: Border.all(
                                color: theme.colorScheme.error.withValues(alpha: 0.3),
                                width: 0.8,
                              ),
                            ),
                            child: Text(
                              l10n?.outOfStock ?? 'نفدت الكمية',
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: theme.colorScheme.error,
                                fontWeight: FontWeight.bold,
                                fontSize: 10.5,
                              ),
                            ),
                          )
                        else if (widget.product.reviewCount > 0)
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.star_rounded,
                                size: 16.0,
                                color: Colors.amber,
                              ),
                              const SizedBox(width: 4.0),
                              Text(
                                widget.product.averageRating.toStringAsFixed(1),
                                style: theme.textTheme.labelMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                ' (${widget.product.reviewCount})',
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Backward compatibility alias
typedef ProductContainer = AppProductCard;
