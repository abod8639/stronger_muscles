import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:stronger_muscles/data/models/product_model.dart';
import 'package:stronger_muscles/presentation/bindings/cart_controller.dart';
import 'package:stronger_muscles/data/models/cart_item_model.dart';
import 'package:stronger_muscles/presentation/bindings/product_details_controller.dart';

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
              Obx(() {
                final selectedImageIndex =
                    productDetailsController.selectedImageIndex.value;
                return Hero(
                  tag: product.id,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12.0),
                    child: CachedNetworkImage(
                      imageUrl: product.imageUrl[selectedImageIndex],
                      placeholder: (context, url) =>
                          const Center(child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                      fit: BoxFit.cover,
                      height: 300,
                      width: double.infinity,
                    ),
                  ),
                );
              }),
              const SizedBox(height: 24.0),

              Text(
                product.name,
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8.0),

              Text(
                'LE ${product.price.toStringAsFixed(2)}',
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(height: 16.0),

              ImageListView(product: product),

              const SizedBox(height: 24.0),
              Text(
                'Description',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8.0),
              Text(product.description, style: theme.textTheme.bodyMedium),
              const SizedBox(height: 32.0),
            ],
          ),
        ),
      ),

      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              Obx(() {
                final isInCart = cartController.isInCart(product);
                final CartItemModel? item = isInCart ? cartController.getCartItem(product) : null;

                return Expanded(
                  child: isInCart
                      ? Card(
                          color: theme.colorScheme.surface.withOpacity(0.1),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.remove),
                                  onPressed: () =>
                                      cartController.decreaseQuantity(item!),
                                ),
                                Text(
                                  item!.quantity.toString(),
                                  style: const TextStyle(fontSize: 18),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.add),
                                  onPressed: () =>
                                      cartController.increaseQuantity(item),
                                ),
                              ],
                            ),
                          ),
                        )
                      : ElevatedButton.icon(
                          onPressed: () {
                            cartController.addToCart(product);
                            Get.snackbar(
                              duration: const Duration(seconds: 1),
                              'Added to cart',
                              '${product.name} was added to your cart.',
                            );
                          },
                          icon: const Icon(Icons.add_shopping_cart),
                          label: const Text('Add to Cart'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: theme.colorScheme.primary,
                            foregroundColor: theme.colorScheme.onPrimary,
                            padding:
                                const EdgeInsets.symmetric(vertical: 16.0),
                            textStyle: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                );
              }),

              const SizedBox(width: 16.0),

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
                  onPressed: () =>
                      productDetailsController.toggleWishlist(),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}

class ImageListView extends StatelessWidget {
  final ProductModel product;
  const ImageListView({required this.product});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProductDetailsController>();

    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: product.imageUrl.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () => controller.selectImage(index),
            child: Obx(() {
              final isSelected =
                  controller.selectedImageIndex.value == index;
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
