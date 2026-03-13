import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stronger_muscles/core/constants/app_colors.dart';
import 'package:stronger_muscles/features/product/data/models/product_model.dart';
import 'package:stronger_muscles/core/utils/functions/cache_manager.dart';
import 'package:stronger_muscles/l10n/generated/app_localizations.dart';
import 'package:stronger_muscles/features/product_details/presentation/controllers/product_details_controller.dart';

class ImageListView extends ConsumerWidget {
  static const double _listHeight = 100.0;
  static const double _thumbnailSize = 90.0;
  static const double _horizontalMargin = 8.0;
  static const double _padding = 4.0;
  static const double _borderWidth = 3.0;
  static const double _borderRadius = 8.0;
  static const Duration _animationDuration = Duration(milliseconds: 200);

  final ScrollController? scrollController;
  final ProductModel product;

  const ImageListView({
    super.key,
    this.scrollController,
    required this.product,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (product.imageUrls.length <= 1) {
      return const SizedBox.shrink();
    }

    final detailsState = ref.watch(productDetailsControllerProvider(product));
    final detailsNotifier = ref.watch(productDetailsControllerProvider(product).notifier);

    return SizedBox(
      height: _listHeight,
      child: ListView.builder(
        controller: scrollController,
        scrollDirection: Axis.horizontal,
        itemCount: product.imageUrls.length,
        physics: const BouncingScrollPhysics(),
        addRepaintBoundaries: true,
        itemBuilder: (context, index) => _buildThumbnail(context, detailsState, detailsNotifier, index),
      ),
    );
  }

  Widget _buildThumbnail(BuildContext context, ProductDetailsState state, ProductDetailsController notifier, int index) {
    final isSelected = state.selectedImageIndex == index;
    final localizations = AppLocalizations.of(context)!;

    return Semantics(
      label: '${localizations.productImage} ${index + 1} of ${product.imageUrls.length}',
      button: true,
      child: GestureDetector(
        onTap: () => notifier.selectImage(index),
        child: AnimatedContainer(
          duration: _animationDuration,
          curve: Curves.easeInOut,
          margin: const EdgeInsets.symmetric(horizontal: _horizontalMargin),
          padding: const EdgeInsets.all(_padding),
          decoration: BoxDecoration(
            border: Border.all(
              color: isSelected ? AppColors.primary : Colors.transparent,
              width: _borderWidth,
            ),
            borderRadius: BorderRadius.circular(_borderRadius),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: .3),
                      blurRadius: 8.0,
                      spreadRadius: 1.0,
                    ),
                  ]
                : null,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(_borderRadius - _padding),
            child: _buildThumbnailImage(context, index),
          ),
        ),
      ),
    );
  }

  Widget _buildThumbnailImage(BuildContext context, int index) {
    final imageUrlModel = product.imageUrls[index];
    final theme = Theme.of(context);

    return CachedNetworkImage(
      cacheManager: CustomCacheManager.instance,
      imageUrl: imageUrlModel.thumbnail,
      fit: BoxFit.cover,
      width: _thumbnailSize,
      height: _thumbnailSize,
      placeholder: (context, url) => Container(
        width: _thumbnailSize,
        height: _thumbnailSize,
        color: theme.colorScheme.surfaceContainerHighest,
        child: const Center(
          child: SizedBox(
            width: 20.0,
            height: 20.0,
            child: CircularProgressIndicator(
              strokeWidth: 2.0,
              color: AppColors.primary,
            ),
          ),
        ),
      ),
      errorWidget: (context, url, error) => Container(
        width: _thumbnailSize,
        height: _thumbnailSize,
        color: theme.colorScheme.surfaceContainerHighest,
        child: const Icon(
          Icons.image_not_supported_outlined,
          color: AppColors.primary,
          size: 32.0,
        ),
      ),
    );
  }
}
