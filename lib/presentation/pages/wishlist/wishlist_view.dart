
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles/presentation/bindings/wishlist_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';

class WishlistView extends GetView<WishlistController> {
  const WishlistView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wishlist'),
      ),
      body: Obx(() {
        if (controller.wishlistItems.isEmpty) {
          return const Center(
            child: Text('Your wishlist is empty.'),
          );
        }
        return ListView.builder(
          itemCount: controller.wishlistItems.length,
          itemBuilder: (context, index) {
            final product = controller.wishlistItems[index];
            return Card(
              margin: const EdgeInsets.all(8.0),
              child: ListTile(
                leading: CachedNetworkImage(
                  imageUrl: product.imageUrl,
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => const CircularProgressIndicator(),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
                title: Text(product.name),
                subtitle: Text('\$${product.price.toStringAsFixed(2)}'),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => controller.removeFromWishlist(product),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
