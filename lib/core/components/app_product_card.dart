import 'package:flutter/material.dart';
import 'package:stronger_muscles/core/components/app_card.dart';
import 'package:stronger_muscles/core/constants/app_colors.dart';
import 'package:stronger_muscles/core/theme/app_radius.dart';
import 'package:stronger_muscles/core/theme/app_shadows.dart';
import 'package:stronger_muscles/features/product/product_feature.dart';
import 'package:stronger_muscles/features/home/home_feature.dart';

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
                              'LE ${widget.product.baseEffectivePrice}',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            if (widget.product.baseHasDiscount)
                              Text(
                                'LE ${widget.product.formattedPrice}',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: Colors.grey,
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                          ],
                        ),
                        if (widget.product.reviewCount > 0)
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
