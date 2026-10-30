import 'package:flutter/material.dart';
import 'package:stronger_muscles/core/components/components.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stronger_muscles/core/constants/app_colors.dart';
import 'package:stronger_muscles/core/theme/app_radius.dart';
import 'package:stronger_muscles/core/theme/app_shadows.dart';
import 'package:stronger_muscles/features/product/product_feature.dart';
import 'package:stronger_muscles/l10n/generated/app_localizations.dart';
import 'package:stronger_muscles/features/product_details/presentation/controllers/product_details_controller.dart';

/// Horizontal thumbnail strip that selects the main image.
class ImageListView extends ConsumerWidget {
  static const double _listHeight = 88.0;
  static const double _thumbnailSize = 72.0;
  static const double _horizontalMargin = 8.0;
  static const double _padding = 4.0;
  static const double _borderWidth = 3.0;
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
    final detailsNotifier = ref.watch(
      productDetailsControllerProvider(product).notifier,
    );

    return SizedBox(
      height: _listHeight,
      child: ListView.builder(
        controller: scrollController,
        scrollDirection: Axis.horizontal,
        itemCount: product.imageUrls.length,
        physics: const BouncingScrollPhysics(),
        addRepaintBoundaries: true,
        itemBuilder: (context, index) =>
            _buildThumbnail(context, detailsState, detailsNotifier, index),
      ),
    );
  }

  Widget _buildThumbnail(
    BuildContext context,
    ProductDetailsState state,
    ProductDetailsController notifier,
    int index,
  ) {
    final isSelected = state.selectedImageIndex == index;
    final localizations = AppLocalizations.of(context)!;

    return Semantics(
      label:
          '${localizations.productImage} ${index + 1} of ${product.imageUrls.length}',
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
            borderRadius: AppRadius.allMd,
            boxShadow: isSelected
                ? AppShadows.colored(AppColors.primary, alpha: 0.3)
                : null,
          ),
          child: _buildThumbnailImage(index),
        ),
      ),
    );
  }

  Widget _buildThumbnailImage(int index) => AppNetworkImage(
        imageUrl: product.imageUrls[index].thumbnail,
        width: _thumbnailSize,
        height: _thumbnailSize,
        borderRadius: AppRadius.allSm,
      );
}
