import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles/data/models/product_model.dart';
import 'package:stronger_muscles/presentation/bindings/cart_controller.dart';
import 'package:stronger_muscles/presentation/bindings/product_details_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ProductDetailsView extends StatelessWidget {
  final ProductModel product;

  const ProductDetailsView({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final cartController = Get.put(CartController());
    final productDetailsController = Get.put(ProductDetailsController(product));

    return Scaffold(
      appBar: AppBar(title: Text(product.name)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: product.id,
              child: CachedNetworkImage(
                imageUrl: product.imageUrl,
                placeholder: (context, url) =>
                    const Center(child: CircularProgressIndicator()),
                errorWidget: (context, url, error) => const Icon(Icons.error),
                fit: BoxFit.cover,
                height: 300,
                width: double.infinity,
              ),
            ),
            const SizedBox(height: 16.0),
            Text(
              product.name,
              style: const TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              '\$${product.price.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 20.0, color: Colors.grey),
            ),
            const SizedBox(height: 16.0),
            Text(product.description, style: const TextStyle(fontSize: 16.0)),
            const SizedBox(height: 32.0),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      cartController.addToCart(product);
                    },
                    child: const Text('Add to Cart'),
                  ),
                ),
                const SizedBox(width: 16.0),
                Obx(() {
                  return IconButton(
                    icon: Icon(
                      productDetailsController.isInWishlist.value
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: productDetailsController.isInWishlist.value
                          ? Colors.red
                          : null,
                    ),
                    onPressed: () {
                      productDetailsController.toggleWishlist();
                    },
                  );
                }),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
