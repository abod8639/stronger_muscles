import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:stronger_muscles/core/components/app_product_card.dart';
import 'package:stronger_muscles/core/theme/theme.dart';
import 'package:stronger_muscles/core/utils/functions/cache_manager.dart';
import 'package:stronger_muscles/features/home/presentation/widgets/image_indicators.dart';
import 'package:stronger_muscles/features/product_details/product_details_feature.dart';
import 'package:stronger_muscles/l10n/generated/app_localizations.dart';

class ImageSection extends StatefulWidget {
  const ImageSection({super.key, required this.widget});

  final ProductContainer widget;

  @override
  State<ImageSection> createState() => _ImageSectionState();
}

class _ImageSectionState extends State<ImageSection> {
  late final PageController _pageController;
  int _selectedImageIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final product = widget.widget.product;
    final images = product.imageUrls;
    final isOutOfStock = !product.isInStock;
    final hasBadges = product.hasDiscount ||
        product.newArrival ||
        product.bestSeller ||
        product.featured;

    final imageWidget = images.isEmpty
        ? buildNoImage(theme)
        : PageView.builder(
            allowImplicitScrolling: true,
            controller: _pageController,
            itemCount: images.length,
            onPageChanged: (index) {
              if (!mounted) return;
              setState(() {
                _selectedImageIndex = index;
              });
              if (widget.widget.onPageChanged != null) {
                widget.widget.onPageChanged!(index);
              }
            },
            itemBuilder: (context, index) {
              if (index < 0 || index >= images.length) {
                return const SizedBox.shrink();
              }
              return buildImage(
                images[index].medium,
                theme,
                product.isBackgroundWhite,
              );
            },
          );

    return GestureDetector(
      onTap: widget.widget.onTap,
      child: Stack(
        children: [
          Container(
            width: double.maxFinite,
            height: double.infinity,
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerLowest,
              borderRadius: AppRadius.top(AppRadius.lg),
            ),
            child: ClipRRect(
              borderRadius: AppRadius.top(AppRadius.lg),
              child: isOutOfStock
                  ? ColorFiltered(
                      colorFilter: const ColorFilter.matrix(<double>[
                        0.2126, 0.7152, 0.0722, 0, 0,
                        0.2126, 0.7152, 0.0722, 0, 0,
                        0.2126, 0.7152, 0.0722, 0, 0,
                        0,      0,      0,      0.65, 0,
                      ]),
                      child: imageWidget,
                    )
                  : imageWidget,
            ),
          ),
          if (images.length > 1)
            ImageIndicators(
              product: product,
              selectedImageIndex: _selectedImageIndex,
            ),
          if (hasBadges && !isOutOfStock)
            PositionedDirectional(
              top: 10.0,
              end: 10.0,
              child: buildProductBadges(product, context, 0.8),
            ),
          if (isOutOfStock)
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.28),
                  borderRadius: AppRadius.top(AppRadius.lg),
                ),
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10.0,
                      vertical: 5.0,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.78),
                      borderRadius: BorderRadius.circular(20.0),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.4),
                        width: 1.0,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.remove_shopping_cart_outlined,
                          size: 13.0,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 4.0),
                        Text(
                          l10n?.outOfStock ?? 'نفدت الكمية',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget buildImage(String url, ThemeData theme, bool isBackgroundWhite) {
    if (url.trim().isEmpty) {
      return buildNoImage(theme);
    }

    return Container(
      margin: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: isBackgroundWhite
            ? Colors.white.withValues(alpha: .9)
            : Colors.transparent,
        borderRadius: AppRadius.allMd,
      ),
      child: ClipRRect(
        borderRadius: AppRadius.allMd,
        child: CachedNetworkImage(
          cacheManager: CustomCacheManager.instance,
          imageUrl: url,
          fit: BoxFit.fitHeight,
          placeholder: (context, url) => buildShimmerEffect(theme),
          errorWidget: (context, url, error) => buildErrorWidget(theme),
        ),
      ),
    );
  }

  Widget buildShimmerEffect(ThemeData theme) {
    return Center(
      child: CircularProgressIndicator(
        strokeWidth: 2.0,
        color: theme.colorScheme.primary.withValues(alpha: .5),
      ),
    );
  }

  Widget buildNoImage(ThemeData theme) {
    return Builder(
      builder: (context) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.image_not_supported_outlined,
                size: 40.0,
                color: theme.colorScheme.outline,
              ),
              const SizedBox(height: 4.0),
              Text(
                AppLocalizations.of(context)?.noImagesFound ?? 'لا توجد صور متاحة',
                style: theme.textTheme.labelSmall,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget buildErrorWidget(ThemeData theme) {
    return Container(
      color: theme.colorScheme.errorContainer.withValues(alpha: .2),
      child: Icon(Icons.broken_image_outlined, color: theme.colorScheme.error),
    );
  }
}
