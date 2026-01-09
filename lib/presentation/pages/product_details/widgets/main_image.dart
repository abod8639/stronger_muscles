import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles/data/models/product_model.dart';
import 'package:stronger_muscles/l10n/generated/app_localizations.dart';
import 'package:stronger_muscles/presentation/bindings/product_details_controller.dart';

class MainImage extends StatefulWidget {
  final ProductModel product;
  final Function(int)? onImageTap;

  const MainImage({
    super.key,
    required this.product,
    this.onImageTap, // Callback for image tap
  });

  @override
  State<MainImage> createState() => _MainImageState();
}

class _MainImageState extends State<MainImage> {
  late final PageController _pageController;
  late final ProductDetailsController _controller;

  @override
  void initState() {
    super.initState();
    _controller = Get.find<ProductDetailsController>();
    _pageController = PageController(
      initialPage: _controller.selectedImageIndex.value,
    );

    // Listen to controller changes to animate PageView
    ever(_controller.selectedImageIndex, (index) {
      if (_pageController.hasClients && _pageController.page?.round() != index) {
        _pageController.animateToPage(
          index,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('DEBUG: MainImage - product.imageUrls: ${widget.product.imageUrls}');
    print('DEBUG: MainImage - product.imageUrls.length: ${widget.product.imageUrls.length}');
    
    // Handle empty image list
    if (widget.product.imageUrls.isEmpty) {
      return SizedBox(
        height: 400,
        width: double.infinity,
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.image_not_supported_outlined,
                  size: 64,
                  color: Theme.of(context).colorScheme.error,
                ),
                const SizedBox(height: 16),
                Text(
                  AppLocalizations.of(context)!.noImagesAvailable,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
          ),
        ),
      );
    }

    return SizedBox(
      height: 400,
      width: double.infinity,
      child: PageView.builder(
      
        controller: _pageController,
        itemCount: widget.product.imageUrls.length,
        onPageChanged: (index) {
          _controller.selectImage(index);
        },
        
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () => widget.onImageTap?.call(index),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12.0),
              child: CachedNetworkImage(
                imageUrl: widget.product.imageUrls[index],
                placeholder: (context, url) =>
                const Center(child: CircularProgressIndicator()),
                errorWidget: (context, url, error) {
                  print('DEBUG: Error loading image from URL: ${widget.product.imageUrls[index]}, Error: $error');
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.broken_image_outlined,
                          size: 48,
                          color: Theme.of(context).colorScheme.error,
                        ),
                        const SizedBox(height: 8),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text(
                            'فشل تحميل الصورة',
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context).colorScheme.error,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
                fit: BoxFit.contain,
              ),
            ),
          );
        },
      ),
    );
  }
}
