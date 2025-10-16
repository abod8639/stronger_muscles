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
    final theme = Theme.of(context);
    final cartController = Get.find<CartController>();
    final productDetailsController = Get.put(ProductDetailsController(product));

    return Scaffold(
      appBar: AppBar(title: Text(product.name)),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Hero(
                tag: product.id,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
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
              ),
              const SizedBox(height: 24.0),
              Text(
                product.name,
                style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8.0),
              Text(
                '\$${product.price.toStringAsFixed(2)}',
                style: theme.textTheme.headlineSmall?.copyWith(color: theme.colorScheme.primary),
              ),
              const SizedBox(height: 24.0),
              Text('Description', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8.0),
              Text(product.description, style: theme.textTheme.bodyMedium),
              const SizedBox(height: 32.0),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    cartController.addToCart(product);
                    Get.snackbar('Added to cart', '${product.name} was added to your cart.');
                  },
                  icon: const Icon(Icons.add_shopping_cart),
                  label: const Text('Add to Cart'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: theme.colorScheme.onPrimary,
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(width: 16.0),
              // 
              // button
              Obx(() {
                return IconButton(
                  icon: Icon(
                    productDetailsController.isInWishlist.value
                        ? Icons.favorite
                        : Icons.favorite_border,
                    color: productDetailsController.isInWishlist.value
                        ? theme.colorScheme.primary
                        : null,
                    size: 32,
                  ),
                  onPressed: () {
                    productDetailsController.toggleWishlist();
                  },
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
