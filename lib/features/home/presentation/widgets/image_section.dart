import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:stronger_muscles/core/components/app_product_card.dart';
import 'package:stronger_muscles/core/theme/theme.dart';
import 'package:stronger_muscles/core/utils/functions/cache_manager.dart';
import 'package:stronger_muscles/features/home/presentation/widgets/image_indicators.dart';
import 'package:stronger_muscles/features/product_details/presentation/widgets/build_product_badges.dart';
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
    final images = widget.widget.product.imageUrls;

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
              child: images.isEmpty
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
                          widget.widget.product.isBackgroundWhite,
                        );
                      },
                    ),
            ),
          ),
          if (images.length > 1)
            ImageIndicators(
              product: widget.widget.product,
              selectedImageIndex: _selectedImageIndex,
            ),
          if (widget.widget.product.discountPrice != null)
            Positioned(
              top: 12.0,
              right: 15.0,
              child: buildProductBadges(widget.widget.product, context, 0.5),
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
