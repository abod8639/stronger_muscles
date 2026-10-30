import 'package:flutter/material.dart';
import 'package:stronger_muscles/core/components/app_badge.dart';
import 'package:stronger_muscles/core/components/app_dots_indicator.dart';
import 'package:stronger_muscles/core/components/app_network_image.dart';
import 'package:stronger_muscles/core/constants/app_colors.dart';
import 'package:stronger_muscles/core/theme/theme.dart';
import 'package:stronger_muscles/features/product/data/models/product_model.dart';
import 'package:stronger_muscles/features/product/presentation/widgets/product_badges.dart';
import 'package:stronger_muscles/l10n/generated/app_localizations.dart';

/// Swipeable image area of [AppProductCard]: image pager with dots,
/// promo badges, and a greyed-out "out of stock" overlay.
class AppProductCardImage extends StatefulWidget {
  final ProductModel product;
  final ValueChanged<int>? onPageChanged;

  const AppProductCardImage({
    super.key,
    required this.product,
    this.onPageChanged,
  });

  @override
  State<AppProductCardImage> createState() => _AppProductCardImageState();
}

class _AppProductCardImageState extends State<AppProductCardImage> {
  static const ColorFilter _greyscale = ColorFilter.matrix(<double>[
    0.2126, 0.7152, 0.0722, 0, 0,
    0.2126, 0.7152, 0.0722, 0, 0,
    0.2126, 0.7152, 0.0722, 0, 0,
    0, 0, 0, 0.65, 0,
  ]);

  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final product = widget.product;
    final images = product.imageUrls;
    final isOutOfStock = !product.isInStock;
    final hasBadges =
        product.hasDiscount || product.newArrival || product.bestSeller || product.featured;
    final radius = AppRadius.top(AppRadius.lg);

    Widget pager = images.isEmpty
        ? const AppNetworkImage(imageUrl: null)
        : PageView.builder(
            allowImplicitScrolling: true,
            itemCount: images.length,
            onPageChanged: (index) {
              setState(() => _selectedIndex = index);
              widget.onPageChanged?.call(index);
            },
            itemBuilder: (context, index) => Container(
              margin: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: product.isBackgroundWhite
                    ? AppColors.white.withValues(alpha: 0.9)
                    : Colors.transparent,
                borderRadius: AppRadius.allMd,
              ),
              child: AppNetworkImage(
                imageUrl: images[index].medium,
                fit: BoxFit.fitHeight,
              ),
            ),
          );

    if (isOutOfStock) {
      pager = ColorFiltered(colorFilter: _greyscale, child: pager);
    }

    return Stack(
      children: [
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: context.colorScheme.surfaceContainerLowest,
              borderRadius: radius,
            ),
            child: ClipRRect(borderRadius: radius, child: pager),
          ),
        ),
        if (images.length > 1)
          Positioned(
            bottom: 10.0,
            left: 0,
            right: 0,
            child: AppDotsIndicator(
              itemCount: images.length,
              currentIndex: _selectedIndex.clamp(0, images.length - 1),
            ),
          ),
        if (hasBadges && !isOutOfStock)
          PositionedDirectional(
            top: 10.0,
            end: 10.0,
            child: buildProductBadges(product, context, 0.8),
          ),
        if (isOutOfStock)
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.28),
                borderRadius: radius,
              ),
              child: Center(
                child: AppBadge(
                  icon: Icons.remove_shopping_cart_outlined,
                  label: l10n?.outOfStock ?? 'نفدت الكمية',
                  color: AppColors.white,
                  backgroundColor: Colors.black.withValues(alpha: 0.78),
                  border: Border.all(color: AppColors.white.withValues(alpha: 0.4)),
                  borderRadius: AppRadius.allPill,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
