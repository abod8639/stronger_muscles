import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stronger_muscles/features/product/data/models/product_model.dart';
import 'package:stronger_muscles/core/utils/functions/cache_manager.dart';
import 'package:stronger_muscles/l10n/generated/app_localizations.dart';
import 'package:stronger_muscles/features/product_details/presentation/controllers/product_details_controller.dart';

class MainImage extends ConsumerStatefulWidget {
  final ProductModel product;
  final Function(int)? onImageTap;

  const MainImage({super.key, required this.product, this.onImageTap});

  @override
  ConsumerState<MainImage> createState() => _MainImageState();
}

class _MainImageState extends ConsumerState<MainImage> {
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    final detailsState = ref.read(productDetailsControllerProvider(widget.product));
    _pageController = PageController(initialPage: detailsState.selectedImageIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Listen for image selection changes to animate the PageController
    ref.listen(productDetailsControllerProvider(widget.product), (previous, next) {
      if (next.selectedImageIndex != previous?.selectedImageIndex) {
        if (_pageController.hasClients && _pageController.page?.round() != next.selectedImageIndex) {
          _pageController.animateToPage(
            next.selectedImageIndex,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        }
      }
    });

    return SizedBox(
      height: 400,
      width: double.infinity,
      child: widget.product.imageUrls.isEmpty
          ? _buildEmptyState(context)
          : _buildImageSlider(context),
    );
  }

  Widget _buildImageSlider(BuildContext context) {
    return PageView.builder(
      allowImplicitScrolling: true,
      controller: _pageController,
      itemCount: widget.product.imageUrls.length,
      onPageChanged: (index) => ref.read(productDetailsControllerProvider(widget.product).notifier).selectImage(index),
      physics: const BouncingScrollPhysics(),
      itemBuilder: (context, index) {
        final imageUrl = widget.product.imageUrls[index];
        return GestureDetector(
          onTap: () => widget.onImageTap?.call(index),
          child: Hero(
            tag: 'product_image_${widget.product.id}_$index',
            child: Container(
              decoration: BoxDecoration(
                color: widget.product.isBackgroundWhite ? Colors.white : Colors.transparent,
              ),
              child: CachedNetworkImage(
                cacheManager: CustomCacheManager.instance,
                imageUrl: imageUrl.medium,
                fit: BoxFit.cover,
                placeholder: (context, url) => const Center(child: CircularProgressIndicator.adaptive()),
                errorWidget: (context, url, error) => _buildErrorWidget(context),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildErrorWidget(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.broken_image_outlined, size: 48, color: Theme.of(context).colorScheme.error),
          const SizedBox(height: 8),
          Text('فشل تحميل الصورة', style: TextStyle(color: Theme.of(context).colorScheme.error)),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: .3),
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.image_not_supported_outlined, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          Text(AppLocalizations.of(context)!.noImagesAvailable),
        ],
      ),
    );
  }
}
