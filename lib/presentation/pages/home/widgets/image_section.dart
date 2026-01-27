import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles/functions/cache_manager.dart';
import 'package:stronger_muscles/presentation/pages/home/widgets/product_container.dart';

class ImageSection extends StatelessWidget {
  const ImageSection({
    super.key,
    required this.widget,
    required PageController pageController,
    required RxInt selectedImageIndex,
  }) : _pageController = pageController,
       _selectedImageIndex = selectedImageIndex;

  final ProductContainer widget;
  final PageController _pageController;
  final RxInt _selectedImageIndex;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final images = widget.product.imageUrls;

    return GestureDetector(
      onTap: widget.onTap,
      child: Stack(
        children: [
          Container(
            width: double.maxFinite,
            height: double.infinity,
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerLowest,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16.0),
              ),
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16.0),
              ),
              child: images.isEmpty
                  ? _buildNoImage(theme)
                  : PageView.builder(
                      allowImplicitScrolling: false,
                      controller: _pageController,
                      itemCount: images.length,
                      onPageChanged:
                          widget.onPageChanged ??
                          (index) => _selectedImageIndex.value = index,
                      itemBuilder: (context, index) {
                        return _buildImage(
                          images[index],
                          theme,
                          widget.product.isBackgroundWhite,
                        );
                      },
                    ),
            ),
          ),

          if (widget.product.discountPrice != null)
            Positioned(
              top: 12,
              right: 15,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.redAccent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'خصم',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  // ويدجت عرض الصورة مع التحميل
  Widget _buildImage(String url, ThemeData theme, bool isBackgroundWhite) {
    return Container(
      margin: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: isBackgroundWhite
            ? Colors.white.withOpacity(0.9)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: CachedNetworkImage(
          cacheManager: CustomCacheManager.instance,
          imageUrl: url,
          fit: BoxFit.fitHeight,
          placeholder: (context, url) => _buildShimmerEffect(theme),
          errorWidget: (context, url, error) => _buildErrorWidget(theme),
          memCacheWidth: 400,
          memCacheHeight: 400,
        ),
      ),
    );
  }

  Widget _buildShimmerEffect(ThemeData theme) {
    return Center(
      child: CircularProgressIndicator(
        strokeWidth: 2,
        color: theme.colorScheme.primary.withOpacity(0.5),
      ),
    );
  }

  Widget _buildNoImage(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.image_not_supported_outlined,
            size: 40,
            color: theme.colorScheme.outline,
          ),
          const SizedBox(height: 4),
          Text('لا توجد صور', style: theme.textTheme.labelSmall),
        ],
      ),
    );
  }

  Widget _buildErrorWidget(ThemeData theme) {
    return Container(
      color: theme.colorScheme.errorContainer.withOpacity(0.2),
      child: Icon(Icons.broken_image_outlined, color: theme.colorScheme.error),
    );
  }
}
