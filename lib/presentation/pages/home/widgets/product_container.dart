import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles/data/models/product_model.dart';
import 'package:stronger_muscles/presentation/controllers/product_image_controller.dart';

class ProductContainer extends StatefulWidget {
  const ProductContainer({
    super.key,
    required this.product,
    required this.theme,
    required this.height,
    this.showName,
    this.scrollController,
  });

  final ProductModel product;
  final ThemeData theme;
  final double height;
  final bool? showName;
  final int? scrollController;

  @override
  State<ProductContainer> createState() => _ProductContainerState();
}

class _ProductContainerState extends State<ProductContainer> {
  late final ProductImageController imageController;

  @override
  void initState() {
    super.initState();
    // register the image controller once for this widget's lifecycle
    imageController = Get.put(ProductImageController());
  }

  @override
  void dispose() {
    // remove controller when this widget is disposed to avoid leaking
    try {
      Get.delete<ProductImageController>();
    } catch (_) {}
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: widget.theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha((255 * 0.05).round()),
            blurRadius: 10.0,
            offset: const Offset(0, 5),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16.0),
                ),
                child: SizedBox(
                  height: widget.height, //180,
                  width: double.infinity,
                  child: PageView.builder(
                    controller: imageController.pageController,
                    itemCount: widget.product.imageUrl.length,
                    onPageChanged: imageController.onPageChanged,
                    itemBuilder: (context, index) {
                      return CachedNetworkImage(
                        imageUrl: widget.product.imageUrl[index],
                        fit: BoxFit.contain,
                        placeholder: (context, url) => Container(
                          color: Colors.grey[200],
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                        errorWidget: (context, url, error) => Container(
                          color: Colors.grey[200],
                          child: const Icon(Icons.error, color: Colors.red),
                        ),
                      );
                    },
                  ),
                ),
              ),
              if (widget.showName != null && widget.showName == true)
                if (widget.product.imageUrl.length > 1)
                  Positioned(
                    bottom: 8.0,
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        widget.product.imageUrl.length,
                        (index) => Obx(() {
                          final isActive = imageController.selectedImageIndex.value == index;
                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            margin: const EdgeInsets.symmetric(horizontal: 4.0),
                            height: 5.0,
                            width: isActive ? 20.0 : 5.0,
                            decoration: BoxDecoration(
                              color: isActive
                                  ? widget.theme.colorScheme.primary
                                  : Colors.grey.withAlpha((255 * 0.7).round()),
                              borderRadius: BorderRadius.circular(12),
                            ),
                          );
                        }),
                      ),
                    ),
                  ),

              const SizedBox.shrink(),
            ],
          ),

          if (widget.showName != null && widget.showName == true)
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.product.name,
                    style: widget.theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    'LE ${widget.product.price.toStringAsFixed(2)}',
                    style: widget.theme.textTheme.bodyLarge?.copyWith(
                      color: widget.theme.colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

          const SizedBox.shrink(),
        ],
      ),
    );
  }
}
