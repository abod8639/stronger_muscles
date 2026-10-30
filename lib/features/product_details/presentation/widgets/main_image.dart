import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stronger_muscles/core/components/components.dart';
import 'package:stronger_muscles/core/constants/app_colors.dart';
import 'package:stronger_muscles/features/product/product_feature.dart';
import 'package:stronger_muscles/features/product_details/presentation/controllers/product_details_controller.dart';

/// Swipeable hero image carousel with page dots; tapping opens the viewer.
class MainImage extends ConsumerStatefulWidget {
  final ProductModel product;
  final Function(int)? onImageTap;

  const MainImage({super.key, required this.product, this.onImageTap});

  @override
  ConsumerState<MainImage> createState() => _MainImageState();
}

class _MainImageState extends ConsumerState<MainImage> {
  static const double _height = 380.0;

  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    final detailsState = ref.read(
      productDetailsControllerProvider(widget.product),
    );
    _pageController = PageController(
      initialPage: detailsState.selectedImageIndex,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Listen for image selection changes to animate the PageController
    ref.listen(productDetailsControllerProvider(widget.product), (
      previous,
      next,
    ) {
      if (next.selectedImageIndex != previous?.selectedImageIndex) {
        if (_pageController.hasClients &&
            _pageController.page?.round() != next.selectedImageIndex) {
          _pageController.animateToPage(
            next.selectedImageIndex,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        }
      }
    });

    final images = widget.product.imageUrls;
    final selectedIndex = ref.watch(
      productDetailsControllerProvider(widget.product).select((s) => s.selectedImageIndex),
    );

    return SizedBox(
      height: _height,
      width: double.infinity,
      child: images.isEmpty
          ? const AppNetworkImage(
              imageUrl: null,
              borderRadius: BorderRadius.zero,
              errorIconSize: 64.0,
            )
          : Stack(
              children: [
                Positioned.fill(child: _buildImageSlider()),
                if (images.length > 1)
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 12.0,
                    child: AppDotsIndicator(
                      itemCount: images.length,
                      currentIndex: selectedIndex.clamp(0, images.length - 1),
                    ),
                  ),
              ],
            ),
    );
  }

  Widget _buildImageSlider() {
    return PageView.builder(
      allowImplicitScrolling: true,
      controller: _pageController,
      itemCount: widget.product.imageUrls.length,
      onPageChanged: (index) => ref
          .read(productDetailsControllerProvider(widget.product).notifier)
          .selectImage(index),
      physics: const BouncingScrollPhysics(),
      itemBuilder: (context, index) => GestureDetector(
        onTap: () => widget.onImageTap?.call(index),
        child: Hero(
          tag: 'product_image_${widget.product.id}_$index',
          child: ColoredBox(
            color: widget.product.isBackgroundWhite ? AppColors.white : Colors.transparent,
            child: AppNetworkImage(
              imageUrl: widget.product.imageUrls[index].medium,
              fit: BoxFit.contain,
              borderRadius: BorderRadius.zero,
              errorIcon: Icons.broken_image_outlined,
              errorIconSize: 48.0,
            ),
          ),
        ),
      ),
    );
  }
}
