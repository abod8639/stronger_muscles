import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles/data/models/product_model.dart';
import 'package:stronger_muscles/presentation/controllers/product_image_controller.dart';

class ImageListView extends StatelessWidget {
  final ScrollController ?scrollController;
  final ProductModel product;
  const ImageListView({
    this.scrollController,
    super.key, required this.product});

  @override
  Widget build(BuildContext context) {

  final controller = Get.find<ProductImageController>();

    return SizedBox(
      height: 100,
      child: ListView.builder(
        controller: scrollController,
        scrollDirection: Axis.horizontal,
        itemCount: product.imageUrl.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () => controller.selectImage(index),
            child: Obx(() {
              final isSelected = controller.selectedImageIndex.value == index;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.symmetric(horizontal: 8),
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: isSelected
                        ? Theme.of(context).colorScheme.primary
                        : Colors.transparent,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: CachedNetworkImage(
                    imageUrl: product.imageUrl[index],
                    fit: BoxFit.cover,
                    width: 90,
                    height: 90,
                    placeholder: (context, url) =>
                        const Center(child: CircularProgressIndicator()),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
                ),
              );
            }),
          );
        },
      ),
    );
  }
}
