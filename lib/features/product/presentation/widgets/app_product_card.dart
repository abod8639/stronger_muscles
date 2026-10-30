import 'package:flutter/material.dart';
import 'package:stronger_muscles/core/components/app_badge.dart';
import 'package:stronger_muscles/core/components/app_card.dart';
import 'package:stronger_muscles/core/components/app_highlight_text.dart';
import 'package:stronger_muscles/core/components/app_price_text.dart';
import 'package:stronger_muscles/features/product/presentation/widgets/app_product_card_image.dart';
import 'package:stronger_muscles/core/constants/app_colors.dart';
import 'package:stronger_muscles/core/theme/theme.dart';
import 'package:stronger_muscles/features/product/data/models/product_model.dart';
import 'package:stronger_muscles/features/product/domain/entities/product_entity.dart';
import 'package:stronger_muscles/l10n/generated/app_localizations.dart';

/// Reusable product card component built on top of [AppCard] with unified
/// [AppRadius.allLg] and theme-adaptive [AppShadows.ofCard].
///
/// Supports both [ProductModel] and [ProductEntity] through factory constructors.
/// The whole card is tappable via [onTap].
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
    final l10n = AppLocalizations.of(context);
    final product = widget.product;
    final isOutOfStock = !product.isInStock;
    final locale = Localizations.localeOf(context).languageCode;

    return AppCard(
      padding: EdgeInsets.zero,
      borderRadius: AppRadius.allLg,
      onTap: widget.onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: AppProductCardImage(
              product: product,
              onPageChanged: widget.onPageChanged,
            ),
          ),
          if (widget.showName ?? false)
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12.0, 8.0, 12.0, 12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _ProductTitle(
                      name: product.getLocalizedName(locale: locale),
                      description: product.getLocalizedDescription(locale: locale),
                      query: widget.query,
                    ),
                    Wrap(
                      alignment: WrapAlignment.spaceBetween,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 8.0,
                      runSpacing: 4.0,
                      children: [
                        AppPriceText(
                          price: product.baseEffectivePrice,
                          originalPrice: !isOutOfStock && product.baseHasDiscount
                              ? product.basePrice
                              : null,
                          fontSize: 13.0,
                          color: isOutOfStock ? context.colorScheme.onSurfaceVariant : null,
                        ),
                        if (isOutOfStock)
                          AppBadge(
                            label: l10n?.outOfStock ?? 'نفدت الكمية',
                            color: AppColors.error,
                            alpha: 0.12,
                            borderRadius: AppRadius.allXs,
                          )
                        else if (product.reviewCount > 0)
                          _CompactRating(
                            rating: product.averageRating,
                            count: product.reviewCount,
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

class _ProductTitle extends StatelessWidget {
  final String name;
  final String description;
  final String? query;

  const _ProductTitle({required this.name, required this.description, this.query});

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        HighlightText(
          text: name,
          query: query ?? '',
          style: textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
            height: 1.15,
            color: context.colorScheme.onSurface,
          ),
        ),
        if (description.isNotEmpty) ...[
          const SizedBox(height: 4.0),
          Text(
            description,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: textTheme.bodySmall?.copyWith(
              color: context.colorScheme.onSurfaceVariant.withValues(alpha: 0.75),
              height: 1.25,
            ),
          ),
        ],
      ],
    );
  }
}

class _CompactRating extends StatelessWidget {
  final double rating;
  final int count;

  const _CompactRating({required this.rating, required this.count});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.star_rounded, size: 16.0, color: AppColors.warning),
        const SizedBox(width: 2.0),
        Text(
          rating.toStringAsFixed(1),
          style: context.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        Text(
          ' ($count)',
          style: context.textTheme.labelSmall?.copyWith(
            color: context.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

/// Backward compatibility alias
typedef ProductContainer = AppProductCard;
