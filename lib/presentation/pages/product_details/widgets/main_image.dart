import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles/data/models/product_model.dart';
import 'package:stronger_muscles/presentation/bindings/product_details_controller.dart';

Obx mainImage(ProductModel product) {
  final productDetailsController = Get.put(ProductDetailsController(product));

  return Obx(() {
    final selectedImageIndex =
        productDetailsController.selectedImageIndex.value;
    return ClipRRect(
      borderRadius: BorderRadius.circular(12.0),
      child: CachedNetworkImage(
        imageUrl: product.imageUrl[selectedImageIndex],
        placeholder: (context, url) =>
        const Center(child: CircularProgressIndicator()),
        errorWidget: (context, url, error) => const Icon(Icons.error),
        fit: BoxFit.contain,
        height: 400,
        width: double.infinity,
      ),
    );
  });
}
