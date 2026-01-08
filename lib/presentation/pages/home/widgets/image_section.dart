import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles/presentation/pages/home/widgets/product_container.dart';

class ImageSection extends StatelessWidget {
  const ImageSection({
    super.key,
    // required this.product,
    required this.widget,
    required PageController pageController,
    required RxInt selectedImageIndex,
  }) : _pageController = pageController,
       _selectedImageIndex = selectedImageIndex;

  // final ProductModel product;
  final ProductContainer widget;
  final PageController _pageController;
  final RxInt _selectedImageIndex;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    print(
      'DEBUG: ImageSection - product.imageUrls: ${widget.product.imageUrls}',
    );

    return GestureDetector(
      onTap: widget.onTap,
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16.0)),
        child: Container(
          width: double.maxFinite,
          color: theme
              .colorScheme
              .surfaceContainerLowest, // Slight background for image
          child: widget.product.imageUrls.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.image_not_supported_outlined,
                        size: 48,
                        color: theme.colorScheme.error,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'لا توجد صور',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.error,
                        ),
                      ),
                    ],
                  ),
                )
              : PageView.builder(
                  controller: _pageController,
                  itemCount: widget.product.imageUrls.length,
                  onPageChanged:
                      widget.onPageChanged ??
                      (index) => _selectedImageIndex.value = index,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(
                        8.0,
                      ), // Padding for the image inside
                      child: CachedNetworkImage(
                        imageUrl: widget.product.imageUrls[index],
                        fit: BoxFit.contain,
                        placeholder: (context, url) => Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                        errorWidget: (context, url, error) {
                          print(
                            'DEBUG: ImageSection - Error loading image: ${widget.product.imageUrls[index]}, Error: $error',
                          );
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.broken_image_outlined,
                                  color: theme.colorScheme.error,
                                  size: 48,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'خطأ تحميل الصورة',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: theme.colorScheme.error,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
        ),
      ),
    );
  }
}
