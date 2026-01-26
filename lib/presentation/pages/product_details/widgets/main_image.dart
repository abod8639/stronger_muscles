import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles/data/models/product_model.dart';
import 'package:stronger_muscles/functions/cache_manager.dart';
import 'package:stronger_muscles/l10n/generated/app_localizations.dart';
import 'package:stronger_muscles/presentation/bindings/product_details_controller.dart';

class MainImage extends StatelessWidget {
  final ProductModel product;
  final Function(int)? onImageTap;

  const MainImage({
    super.key,
    required this.product,
    this.onImageTap,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProductDetailsController(product), tag: product.id);
    // final controller = Get.find<ProductDetailsController>(tag: product.id);
    // استخدام Obx فقط عند الحاجة لتغيير الـ PageView برمجياً
    return SizedBox(
      height: 400,
      width: double.infinity,
      child: product.imageUrls.isEmpty
          ? _buildEmptyState(context)
          : _buildImageSlider(context, controller),
    );
  }

  Widget _buildImageSlider(BuildContext context, ProductDetailsController controller) {
    return PageView.builder(
    
      controller: controller.pageController,
      itemCount: product.imageUrls.length,
      onPageChanged: controller.selectImage,
      physics: const BouncingScrollPhysics(),
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () => onImageTap?.call(index),
          child: Hero(
            tag: 'product_image_${product.id}_$index',
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 8.0),
              decoration: BoxDecoration(
                color: product.isBackgroundWhite ? Colors.white : Colors.transparent,
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16.0),
                child: CachedNetworkImage(
                  cacheManager: CustomCacheManager.instance,
                  imageUrl: product.imageUrls[index],
                  fit: BoxFit.contain,
                  placeholder: (context, url) => _buildPlaceholder(),
                  errorWidget: (context, url, error) => _buildErrorWidget(context),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildPlaceholder() {
    return const Center(
      child: CircularProgressIndicator.adaptive(), // يتكيف مع شكل أندرويد أو iOS
    );
  }

  Widget _buildErrorWidget(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.broken_image_outlined, 
               size: 48, color: Theme.of(context).colorScheme.error),
          const SizedBox(height: 8),
          Text('فشل تحميل الصورة',
              style: TextStyle(color: Theme.of(context).colorScheme.error)),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
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