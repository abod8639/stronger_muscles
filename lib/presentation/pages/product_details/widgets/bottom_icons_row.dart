import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles/data/models/cart_item_model.dart';
import 'package:stronger_muscles/data/models/product_model.dart';
import 'package:stronger_muscles/presentation/bindings/cart_controller.dart';
import 'package:stronger_muscles/presentation/bindings/product_details_controller.dart';

Widget bottomIconsRow( ProductModel product) {
  final cartController = Get.find<CartController>();
  final productDetailsController = Get.put(ProductDetailsController(product));
  return Builder(
    builder: (context) {
      final theme = Theme.of(context);
      return BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              Obx(() {
                final isInCart = cartController.isInCart(product);
                final CartItemModel? item = isInCart
                    ? cartController.getCartItem(product)
                    : null;
      
                return Expanded(
                  child: isInCart
                      ? Card(
                          color: theme.colorScheme.surface.withAlpha(
                            (255 * 0.1).round(),
                          ),
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
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
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
                  onPressed: () => productDetailsController.toggleWishlist(),
                );
              }),
            ],
          ),
        ),
      );
    }
  );
}
